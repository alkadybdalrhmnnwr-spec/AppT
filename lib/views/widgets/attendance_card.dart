// lib/views/widgets/attendance_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/student_model.dart';
import '../../notifiers/attendance_notifier.dart';

class AttendanceCard extends ConsumerWidget {
  final StudentModel student;

  const AttendanceCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: student.isPresent ? Colors.green.shade100 : Colors.red.shade100,
          child: Text(
            student.fullName.substring(0, 1),
            style: TextStyle(
              color: student.isPresent ? Colors.green.shade800 : Colors.red.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('الرقم الأكاديمي: ${student.academicId}'),
        trailing: Switch(
          value: student.isPresent,
          activeColor: Colors.green,
          onChanged: (value) {
            final previousState = student;
            ref.read(attendanceProvider.notifier).toggleAttendance(student.id);

            // إظهار SnackBar تفاعلي مع إمكانية التراجع (Undo)
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم تحديث حالة الطالب: ${student.fullName}'),
                action: SnackBarAction(
                  label: 'تراجع (Undo)',
                  onPressed: () {
                    ref
                        .read(attendanceProvider.notifier)
                        .updateStudentState(previousState);
                  },
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          },
        ),
      ),
    );
  }
}