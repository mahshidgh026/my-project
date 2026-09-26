class ClassModel {
  final int id;
  final String name;
  final int grade;
  final int studentCount;

  ClassModel({
    required this.id,
    required this.name,
    required this.grade,
    this.studentCount = 0,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      grade: json['grade'] is int ? json['grade'] : int.parse(json['grade'].toString()),
      studentCount: json['student_count'] != null 
          ? int.parse(json['student_count'].toString()) 
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'student_count': studentCount,
    };
  }
}
