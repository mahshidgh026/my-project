import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/class_model.dart';
import '../models/student_model.dart';
import '../models/attendance_record_model.dart';
import '../models/dashboard_summary_model.dart';

class ApiService {
  // ArvanCloud Server URL
  static String baseUrl = 'http://85.198.51.92:5000/api';
  
  static const String tokenKey = 'arvan_auth_token';
  static const String userKey = 'arvan_cached_user';

  static String? _cachedToken;

  static void setBaseUrl(String newUrl) {
    baseUrl = newUrl;
  }

  static Future<void> saveToken(String token) async {
    _cachedToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    final prefs = await SharedPreferences.getInstance();
    _cachedToken = prefs.getString(tokenKey);
    return _cachedToken;
  }

  static Future<void> clearAuth() async {
    _cachedToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove(userKey);
  }

  static Future<Map<String, String>> _getHeaders({bool withAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (withAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // --- Auth APIs ---

  static Future<Map<String, dynamic>> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(withAuth: false),
      body: jsonEncode({'phone': phone, 'password': password}),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      await saveToken(data['token']);
      return {
        'success': true,
        'user': UserModel.fromJson(data['user']),
        'token': data['token'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'خطا در ورود به سامانه',
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
    required String role,
    int? classId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(withAuth: false),
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'password': password,
        'role': role,
        'class_id': classId,
      }),
    );

    final data = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 201) {
      await saveToken(data['token']);
      return {
        'success': true,
        'user': UserModel.fromJson(data['user']),
        'token': data['token'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'خطا در ثبت‌نام',
      };
    }
  }

  static Future<UserModel?> getMe() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _getHeaders(withAuth: true),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return UserModel.fromJson(data['user']);
      }
    } catch (_) {}
    return null;
  }

  // --- Classes & Students ---

  static Future<List<ClassModel>> getClasses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/classes'),
      headers: await _getHeaders(withAuth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => ClassModel.fromJson(e)).toList();
    } else {
      throw Exception('خطا در دریافت لیست کلاس‌ها');
    }
  }

  static Future<List<StudentModel>> getStudents(int classId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/students?class_id=$classId'),
      headers: await _getHeaders(withAuth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => StudentModel.fromJson(e)).toList();
    } else {
      throw Exception('خطا در دریافت لیست دانش‌آموزان');
    }
  }

  // --- Attendance ---

  static Future<List<AttendanceRecordModel>> getAttendanceByClassAndDate(int classId, String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/attendance?class_id=$classId&date=$date'),
      headers: await _getHeaders(withAuth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((e) => AttendanceRecordModel.fromJson(e)).toList();
    } else {
      throw Exception('خطا در دریافت لیست حضور غیاب');
    }
  }

  static Future<bool> submitAttendanceBatch({
    required int classId,
    required String date,
    required List<AttendanceRecordModel> records,
  }) async {
    final payload = {
      'class_id': classId,
      'date': date,
      'records': records.map((r) => r.toBatchJson()).toList(),
    };

    final response = await http.post(
      Uri.parse('$baseUrl/attendance/batch'),
      headers: await _getHeaders(withAuth: true),
      body: jsonEncode(payload),
    );

    return response.statusCode == 200;
  }

  // --- Principal / Staff Dashboard ---

  static Future<DashboardSummaryModel> getDashboardSummary(String date) async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/summary?date=$date'),
      headers: await _getHeaders(withAuth: true),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return DashboardSummaryModel.fromJson(data);
    } else {
      throw Exception('خطا در دریافت خلاصه آمار مدرسه');
    }
  }

  static Future<List<Map<String, dynamic>>> getAbsentees(String date, {int? classId}) async {
    String url = '$baseUrl/dashboard/absentees?date=$date';
    if (classId != null) {
      url += '&class_id=$classId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(withAuth: true),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('خطا در دریافت لیست غایبین');
    }
  }
}
