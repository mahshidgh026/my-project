class StudentModel {
  final int id;
  final String firstName;
  final String lastName;
  final int classId;
  final String? studentCode;
  final String? parentPhone;
  final String? className;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.classId,
    this.studentCode,
    this.parentPhone,
    this.className,
  });

  String get fullName => '$firstName $lastName';

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      classId: json['class_id'] is int ? json['class_id'] : int.parse(json['class_id'].toString()),
      studentCode: json['student_code'],
      parentPhone: json['parent_phone'],
      className: json['class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'class_id': classId,
      'student_code': studentCode,
      'parent_phone': parentPhone,
      'class_name': className,
    };
  }
}
