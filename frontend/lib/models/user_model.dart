class UserModel {
  final int id;
  final String name;
  final String phone;
  final String role; // 'principal', 'staff', 'teacher'
  final int? classId;
  final String? className;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.classId,
    this.className,
  });

  bool get isPrincipalOrStaff => role == 'principal' || role == 'staff';
  bool get isTeacher => role == 'teacher';

  String get roleDisplayTitle {
    switch (role) {
      case 'principal':
        return 'مدیر دبستان';
      case 'staff':
        return 'کادر اجرایی / معاون';
      case 'teacher':
        return 'آموزگار پایه';
      default:
        return 'همکار محترم';
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'teacher',
      classId: json['class_id'] != null ? int.tryParse(json['class_id'].toString()) : null,
      className: json['class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'class_id': classId,
      'class_name': className,
    };
  }
}
