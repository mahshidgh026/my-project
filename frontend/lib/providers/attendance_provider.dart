import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../models/attendance_record_model.dart';
import '../models/dashboard_summary_model.dart';
import '../services/api_service.dart';
import '../utils/shamsi_helper.dart';

class AttendanceProvider extends ChangeNotifier {
  String _selectedDate = ShamsiHelper.getTodayShamsiIso();
  List<ClassModel> _classes = [];
  ClassModel? _selectedClass;
  List<AttendanceRecordModel> _attendanceRecords = [];
  DashboardSummaryModel? _dashboardSummary;
  List<Map<String, dynamic>> _absenteesList = [];

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  String get selectedDate => _selectedDate;
  List<ClassModel> get classes => _classes;
  ClassModel? get selectedClass => _selectedClass;
  List<AttendanceRecordModel> get attendanceRecords => _attendanceRecords;
  DashboardSummaryModel? get dashboardSummary => _dashboardSummary;
  List<Map<String, dynamic>> get absenteesList => _absenteesList;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;

  void setDate(String newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }

  void setSelectedClass(ClassModel? classModel) {
    _selectedClass = classModel;
    notifyListeners();
    if (classModel != null) {
      loadAttendanceForClass(classModel.id);
    }
  }

  // Load all classes
  Future<void> fetchClasses({int? defaultClassId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _classes = await ApiService.getClasses();
      if (_classes.isNotEmpty) {
        if (defaultClassId != null) {
          _selectedClass = _classes.firstWhere(
            (c) => c.id == defaultClassId,
            orElse: () => _classes.first,
          );
        } else if (_selectedClass == null) {
          _selectedClass = _classes.first;
        }
        await loadAttendanceForClass(_selectedClass!.id);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load attendance records for specific class and current date
  Future<void> loadAttendanceForClass(int classId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _attendanceRecords = await ApiService.getAttendanceByClassAndDate(classId, _selectedDate);
    } catch (e) {
      _errorMessage = 'خطا در بارگذاری اطلاعات کلاس';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update a single student status in memory
  void updateStudentStatus(int studentId, String newStatus, {String? notes}) {
    final index = _attendanceRecords.indexWhere((r) => r.studentId == studentId);
    if (index != -1) {
      _attendanceRecords[index].status = newStatus;
      if (notes != null) {
        _attendanceRecords[index].notes = notes;
      }
      notifyListeners();
    }
  }

  // Mark all students present with 1 click
  void markAllPresent() {
    for (var record in _attendanceRecords) {
      record.status = 'present';
    }
    notifyListeners();
  }

  // Save attendance batch to AbrArvan server
  Future<bool> saveAttendance() async {
    if (_selectedClass == null) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      final success = await ApiService.submitAttendanceBatch(
        classId: _selectedClass!.id,
        date: _selectedDate,
        records: _attendanceRecords,
      );
      _isSubmitting = false;
      notifyListeners();
      return success;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  // Load Principal / Staff Dashboard
  Future<void> fetchDashboard() async {
    _isLoading = true;
    notifyListeners();

    try {
      final summary = await ApiService.getDashboardSummary(_selectedDate);
      final absentees = await ApiService.getAbsentees(_selectedDate);
      _dashboardSummary = summary;
      _absenteesList = absentees;
    } catch (e) {
      _errorMessage = 'خطا در بارگذاری داده‌های داشبورد';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
