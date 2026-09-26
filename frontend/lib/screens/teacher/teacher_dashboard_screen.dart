import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/stat_badge.dart';
import '../../widgets/attendance_chip.dart';
import '../../widgets/custom_card.dart';
import '../../utils/shamsi_helper.dart';
import '../login_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final attendance = Provider.of<AttendanceProvider>(context, listen: false);
      attendance.fetchClasses(defaultClassId: auth.currentUser?.classId);
    });
  }

  void _showNoteDialog(int studentId, String currentNote, String studentName) {
    final noteController = TextEditingController(text: currentNote);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('یادداشت غیبت / توضیحات برای $studentName', style: const TextStyle(fontSize: 15)),
        content: TextField(
          controller: noteController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'علت غیبت یا تاخیر، تماس با مادر دانش‌آموز و ...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AttendanceProvider>(context, listen: false)
                  .updateStudentStatus(
                studentId,
                Provider.of<AttendanceProvider>(context, listen: false)
                    .attendanceRecords
                    .firstWhere((r) => r.studentId == studentId)
                    .status,
                notes: noteController.text.trim(),
              );
              Navigator.pop(ctx);
            },
            child: const Text('ثبت یادداشت'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    final attendance = Provider.of<AttendanceProvider>(context, listen: false);
    final success = await attendance.saveAttendance();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ لیست حضور و غیاب با موفقیت در سرور مدرسه ثبت شد.'),
          backgroundColor: Color(0xFF00B894),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('خطا در ذخیره‌سازی اطلاعات در سرور ابر آروان.'),
          backgroundColor: Color(0xFFFF7675),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final attendance = Provider.of<AttendanceProvider>(context);

    // Calculate quick counts
    int presentCount = 0;
    int absentCount = 0;
    int lateCount = 0;

    for (var r in attendance.attendanceRecords) {
      if (r.status == 'present') presentCount++;
      else if (r.status.startsWith('absent')) absentCount++;
      else if (r.status == 'late') lateCount++;
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('دفتر حضور و غیاب کلاسی'),
            Text(
              auth.currentUser?.name ?? 'آموزگار محترم',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'خروج از حساب',
            onPressed: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: attendance.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top Class & Date Bar
                CustomCard(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: attendance.selectedClass?.id,
                              decoration: const InputDecoration(
                                labelText: 'کلاس آموزشی',
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: attendance.classes.map((c) {
                                return DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text('پایه ${c.name} (${ShamsiHelper.toPersianDigits(c.studentCount)} نفر)'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  final sel = attendance.classes.firstWhere((c) => c.id == val);
                                  attendance.setSelectedClass(sel);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Date Display Container
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C5CE7).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF6C5CE7).withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined, size: 16, color: Color(0xFF6C5CE7)),
                                const SizedBox(width: 6),
                                Text(
                                  ShamsiHelper.formatFriendlyShamsi(attendance.selectedDate),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6C5CE7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatBadge(
                            title: 'کل دانش‌آموزان',
                            count: attendance.attendanceRecords.length,
                            color: Colors.blueGrey,
                            icon: Icons.people_outline,
                          ),
                          StatBadge(
                            title: 'حاضر',
                            count: presentCount,
                            color: const Color(0xFF00B894),
                            icon: Icons.check_circle_outline,
                          ),
                          StatBadge(
                            title: 'غایب',
                            count: absentCount,
                            color: const Color(0xFFFF7675),
                            icon: Icons.cancel_outlined,
                          ),
                          StatBadge(
                            title: 'تأخیر',
                            count: lateCount,
                            color: const Color(0xFFE67E22),
                            icon: Icons.access_time,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Fast Action Bar: "Mark All Present"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'لیست اسامی (${ShamsiHelper.toPersianDigits(attendance.attendanceRecords.length)} نفر):',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.done_all, size: 16),
                        label: const Text('ثبت همه به عنوان حاضر', style: TextStyle(fontSize: 12)),
                        onPressed: attendance.markAllPresent,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF00B894),
                        ),
                      ),
                    ],
                  ),
                ),

                // Student Attendance List
                Expanded(
                  child: attendance.attendanceRecords.isEmpty
                      ? const Center(child: Text('دانش‌آموزی برای این کلاس ثبت نشده است.'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 90),
                          itemCount: attendance.attendanceRecords.length,
                          itemBuilder: (context, index) {
                            final record = attendance.attendanceRecords[index];
                            return CustomCard(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: const Color(0xFF6C5CE7).withOpacity(0.12),
                                        child: Text(
                                          ShamsiHelper.toPersianDigits(index + 1),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6C5CE7),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          record.fullName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          record.notes != null && record.notes!.isNotEmpty
                                              ? Icons.chat_bubble
                                              : Icons.chat_bubble_outline,
                                          size: 18,
                                          color: record.notes != null && record.notes!.isNotEmpty
                                              ? const Color(0xFF6C5CE7)
                                              : Colors.grey,
                                        ),
                                        tooltip: 'یادداشت یا دلیل غیبت',
                                        onPressed: () => _showNoteDialog(
                                          record.studentId,
                                          record.notes ?? '',
                                          record.fullName,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (record.notes != null && record.notes!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8, right: 36),
                                      child: Text(
                                        'یادداشت: ${record.notes}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.purple.shade700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  AttendanceStatusSelector(
                                    currentStatus: record.status,
                                    onStatusChanged: (newStatus) {
                                      attendance.updateStudentStatus(record.studentId, newStatus);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: attendance.isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.cloud_upload_outlined),
            label: Text(attendance.isSubmitting ? 'در حال ارسال به سرور...' : 'ثبت و ارسال حضور و غیاب'),
            onPressed: attendance.isSubmitting ? null : _handleSave,
          ),
        ),
      ),
    );
  }
}
