// lib/views/attendance_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/attendance_notifier.dart';
import 'widgets/statistics_header.dart';
import 'widgets/attendance_card.dart';

class AttendancePage extends ConsumerWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    const textDirection = TextDirection.rtl;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شاشة تحضير الطلاب المتكاملة'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'تحضير الكل',
              onPressed: () {
                ref.read(attendanceProvider.notifier).markAllPresent();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تحضير جميع الطلاب بنجاح')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'تصفير الكشف',
              onPressed: () {
                ref.read(attendanceProvider.notifier).clearAttendance();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تصفير كشف الحضور')),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // الشريط العلوي الإحصائي
            const StatisticsHeader(),
            
            // حقل البحث الفوري
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                onChanged: (value) {
                  ref.read(attendanceProvider.notifier).setSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'بحث فوري بالاسم أو الرقم الأكاديمي...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ),
            
            // قائمة الطلاب التفاعلية
            Expanded(
              child: attendanceState.filteredStudents.isEmpty
                  ? const Center(
                      child: Text(
                        'لا يوجد طلاب مطابقي للبحث',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: attendanceState.filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = attendanceState.filteredStudents[index];
                        return AttendanceCard(student: student);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}