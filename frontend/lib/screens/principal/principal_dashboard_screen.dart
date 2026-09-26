import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/stat_badge.dart';
import '../../widgets/custom_card.dart';
import '../../utils/shamsi_helper.dart';
import 'absentees_list_screen.dart';
import '../login_screen.dart';

class PrincipalDashboardScreen extends StatefulWidget {
  const PrincipalDashboardScreen({super.key});

  @override
  State<PrincipalDashboardScreen> createState() => _PrincipalDashboardScreenState();
}

class _PrincipalDashboardScreenState extends State<PrincipalDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceProvider>(context, listen: false).fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final attendance = Provider.of<AttendanceProvider>(context);
    final summary = attendance.dashboardSummary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('میز کار مدیر و کادر مدرسه'),
            Text(
              auth.currentUser?.name ?? 'مدیریت محترم دبستان',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'به‌روزرسانی داده‌ها',
            onPressed: () => attendance.fetchDashboard(),
          ),
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
          : RefreshIndicator(
              onRefresh: () => attendance.fetchDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date & School Greeting Card
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C5CE7).withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'وضعیت حضور و غیاب مدرسه',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ShamsiHelper.formatFriendlyShamsi(attendance.selectedDate),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'درصد حضور: ${ShamsiHelper.toPersianDigits(summary?.overall.attendancePercentage ?? 0)}٪',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Overall Summary Metrics Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatBadge(
                              title: 'کل دانش‌آموزان',
                              count: summary?.overall.totalStudents ?? 0,
                              color: Colors.blueGrey,
                              icon: Icons.people_alt_outlined,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: StatBadge(
                              title: 'حاضران امروز',
                              count: summary?.overall.present ?? 0,
                              color: const Color(0xFF00B894),
                              icon: Icons.check_circle_outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatBadge(
                              title: 'غایبان کل',
                              count: summary?.overall.totalAbsent ?? 0,
                              color: const Color(0xFFFF7675),
                              icon: Icons.person_off_outlined,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: StatBadge(
                              title: 'تأخیری‌ها',
                              count: summary?.overall.late ?? 0,
                              color: const Color(0xFFE67E22),
                              icon: Icons.access_time,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Absentees Shortcut Card
                    CustomCard(
                      color: const Color(0xFFFFF2F2),
                      border: Border.all(color: const Color(0xFFFF7675).withOpacity(0.3)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AbsenteesListScreen()),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7675).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notification_important_rounded,
                              color: Color(0xFFFF7675),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'مشاهده لیست غایبین و تماس با اولیا',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFFD63031),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'تعداد ${ShamsiHelper.toPersianDigits(attendance.absenteesList.length)} دانش‌آموز غایب یا دارای تأخیر',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFFD63031)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'وضعیت حضور و غیاب به تفکیک پایه‌ها و کلاس‌ها:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Classes List Breakdown
                    if (summary?.classes.isEmpty ?? true)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text('کلاسی یافت نشد.'),
                        ),
                      )
                    else
                      ...summary!.classes.map((cls) {
                        final isRecorded = cls.isSubmitted;
                        final percent = cls.totalStudents > 0
                            ? ((cls.presentCount + cls.lateCount) / cls.totalStudents)
                            : 0.0;

                        return CustomCard(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'کلاس پایه ${cls.className}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isRecorded
                                          ? const Color(0xFF00B894).withOpacity(0.12)
                                          : const Color(0xFFF39C12).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isRecorded ? Icons.check_circle : Icons.hourglass_top,
                                          size: 13,
                                          color: isRecorded ? const Color(0xFF00B894) : const Color(0xFFF39C12),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          isRecorded ? 'ثبت شده' : 'در انتظار ثبت معلم',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isRecorded ? const Color(0xFF00B894) : const Color(0xFFF39C12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: percent.clamp(0.0, 1.0),
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  percent > 0.8
                                      ? const Color(0xFF00B894)
                                      : percent > 0.5
                                          ? const Color(0xFFF39C12)
                                          : const Color(0xFFFF7675),
                                ),
                                borderRadius: BorderRadius.circular(4),
                                minHeight: 6,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'کل: ${ShamsiHelper.toPersianDigits(cls.totalStudents)} نفر',
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                  ),
                                  Text(
                                    'حاضر: ${ShamsiHelper.toPersianDigits(cls.presentCount)}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF00B894), fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'غایب: ${ShamsiHelper.toPersianDigits(cls.totalAbsent)}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFFFF7675), fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'تأخیر: ${ShamsiHelper.toPersianDigits(cls.lateCount)}',
                                    style: const TextStyle(fontSize: 12, color: Color(0xFFE67E22)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }
}
