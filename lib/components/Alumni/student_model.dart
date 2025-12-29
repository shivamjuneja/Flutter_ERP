// lib/student_model.dart
class Student {
  final String admissionNo;
  final String name;
  final String className;
  final String section;
  final String gender;
  final String email;
  final String phone;
  final String passOutSession;
  final String status;

  Student({
    required this.admissionNo,
    required this.name,
    required this.className,
    required this.section,
    required this.gender,
    required this.email,
    required this.phone,
    required this.passOutSession,
    required this.status,
  });
}