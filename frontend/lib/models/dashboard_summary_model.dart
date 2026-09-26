class DashboardSummaryModel {
  final String date;
  final OverallStats overall;
  final List<ClassAttendanceStats> classes;

  DashboardSummaryModel({
    required this.date,
    required this.overall,
    required this.classes,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      date: json['date'] ?? '',
      overall: OverallStats.fromJson(json['overall'] ?? {}),
      classes: (json['classes'] as List? ?? [])
          .map((c) => ClassAttendanceStats.fromJson(c))
          .toList(),
    );
  }
}

class OverallStats {
  final int totalStudents;
  final int totalRecorded;
  final int present;
  final int absentUnexcused;
  final int absentExcused;
  final int late;
  final int attendancePercentage;

  OverallStats({
    required this.totalStudents,
    required this.totalRecorded,
    required this.present,
    required this.absentUnexcused,
    required this.absentExcused,
    required this.late,
    required this.attendancePercentage,
  });

  int get totalAbsent => absentUnexcused + absentExcused;

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalStudents: json['total_students'] ?? 0,
      totalRecorded: json['total_recorded'] ?? 0,
      present: json['present'] ?? 0,
      absentUnexcused: json['absent_unexcused'] ?? 0,
      absentExcused: json['absent_excused'] ?? 0,
      late: json['late'] ?? 0,
      attendancePercentage: json['attendance_percentage'] ?? 0,
    );
  }
}

class ClassAttendanceStats {
  final int classId;
  final String className;
  final int grade;
  final int totalStudents;
  final int presentCount;
  final int absentUnexcusedCount;
  final int absentExcusedCount;
  final int lateCount;
  final int recordedCount;
  final bool isSubmitted;

  ClassAttendanceStats({
    required this.classId,
    required this.className,
    required this.grade,
    required this.totalStudents,
    required this.presentCount,
    required this.absentUnexcusedCount,
    required this.absentExcusedCount,
    required this.lateCount,
    required this.recordedCount,
    required this.isSubmitted,
  });

  int get totalAbsent => absentUnexcusedCount + absentExcusedCount;

  factory ClassAttendanceStats.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceStats(
      classId: json['class_id'] is int ? json['class_id'] : int.parse(json['class_id'].toString()),
      className: json['class_name'] ?? '',
      grade: json['grade'] is int ? json['grade'] : int.parse(json['grade'].toString()),
      totalStudents: json['total_students'] ?? 0,
      presentCount: json['present_count'] ?? 0,
      absentUnexcusedCount: json['absent_unexcused_count'] ?? 0,
      absentExcusedCount: json['absent_excused_count'] ?? 0,
      lateCount: json['late_count'] ?? 0,
      recordedCount: json['recorded_count'] ?? 0,
      isSubmitted: json['is_submitted'] == true || json['is_submitted'] == 1,
    );
  }
}
