// lib/models/student_model.dart

class StudentModel {
  final String id;
  final String fullName;
  final String academicId;
  final bool isPresent;
  final String absenceNotes;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    this.isPresent = false,
    this.absenceNotes = '',
  });

  StudentModel copyWith({
    String? id,
    String? fullName,
    String? academicId,
    bool? isPresent,
    String? absenceNotes,
  }) {
    return StudentModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      academicId: academicId ?? this.academicId,
      isPresent: isPresent ?? this.isPresent,
      absenceNotes: absenceNotes ?? this.absenceNotes,
    );
  }
}