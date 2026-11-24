// lib/notifiers/attendance_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_model.dart';

class AttendanceState {
  final List<StudentModel> students;
  final String searchQuery;

  AttendanceState({
    required this.students,
    this.searchQuery = '',
  });

  List<StudentModel> get filteredStudents {
    if (searchQuery.isEmpty) {
      return students;
    }
    return students.where((student) {
      return student.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          student.academicId.contains(searchQuery);
    }).toList();
  }

  int get totalStudents => students.length;
  int get presentCount => students.where((s) => s.isPresent).length;
  int get absentCount => totalStudents - presentCount;
  double get attendancePercentage =>
      totalStudents == 0 ? 0.0 : (presentCount / totalStudents) * 100;
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier()
      : super(AttendanceState(students: [
          StudentModel(id: '1', fullName: 'أحمد محمد علي الحرازي', academicId: '2021001', isPresent: true),
          StudentModel(id: '2', fullName: 'محمد عبد الله الإرياني', academicId: '2021002', isPresent: false),
          StudentModel(id: '3', fullName: 'إبراهيم علي المتوكل', academicId: '2021003', isPresent: true),
          StudentModel(id: '4', fullName: 'فاطمة أحمد المؤيد', academicId: '2021004', isPresent: false),
          StudentModel(id: '5', fullName: 'سارة خالد الشميري', academicId: '2021005', isPresent: true),
        ]));

  void setSearchQuery(String query) {
    state = AttendanceState(students: state.students, searchQuery: query);
  }

  void toggleAttendance(String id) {
    final updatedStudents = state.students.map((student) {
      if (student.id == id) {
        return student.copyWith(isPresent: !student.isPresent);
      }
      return student;
    }).toList();

    state = AttendanceState(students: updatedStudents, searchQuery: state.searchQuery);
  }

  // ميزة التراجع (Undo) عند التعديل الفردي
  void updateStudentState(StudentModel modifiedStudent) {
    final updatedStudents = state.students.map((student) {
      return student.id == modifiedStudent.id ? modifiedStudent : student;
    }).toList();
    state = AttendanceState(students: updatedStudents, searchQuery: state.searchQuery);
  }

  void markAllPresent() {
    final updatedStudents = state.students.map((student) {
      return student.copyWith(isPresent: true);
    }).toList();
    state = AttendanceState(students: updatedStudents, searchQuery: state.searchQuery);
  }

  void clearAttendance() {
    final updatedStudents = state.students.map((student) {
      return student.copyWith(isPresent: false);
    }).toList();
    state = AttendanceState(students: updatedStudents, searchQuery: state.searchQuery);
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier();
});