class AttendanceRecordModel {
  final int studentId;
  final String firstName;
  final String lastName;
  final String? studentCode;
  final String? parentPhone;
  String status; // 'present', 'absent_unexcused', 'absent_excused', 'late'
  String? notes;
  final String? date;
  final String? recordedByName;

  AttendanceRecordModel({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    this.studentCode,
    this.parentPhone,
    this.status = 'present',
    this.notes,
    this.date,
    this.recordedByName,
  });

  String get fullName => '$firstName $lastName';

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      studentId: json['student_id'] is int 
          ? json['student_id'] 
          : int.parse(json['student_id'].toString()),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      studentCode: json['student_code'],
      parentPhone: json['parent_phone'],
      status: json['status'] ?? 'present',
      notes: json['notes'],
      date: json['date'],
      recordedByName: json['recorded_by_name'],
    );
  }

  Map<String, dynamic> toBatchJson() {
    return {
      'student_id': studentId,
      'status': status,
      'notes': notes,
    };
  }
}
