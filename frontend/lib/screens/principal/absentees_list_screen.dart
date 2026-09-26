import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/custom_card.dart';
import '../../utils/shamsi_helper.dart';

class AbsenteesListScreen extends StatefulWidget {
  const AbsenteesListScreen({super.key});

  @override
  State<AbsenteesListScreen> createState() => _AbsenteesListScreenState();
}

class _AbsenteesListScreenState extends State<AbsenteesListScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  void _callParent(String phone, String studentName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تماس با ولی دانش‌آموز', style: TextStyle(fontSize: 16)),
        content: Text(
          'آیا مایل به برقراری تماس با اولیای $studentName به شماره ${ShamsiHelper.toPersianDigits(phone)} هستید؟',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('انصراف'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.phone),
            label: const Text('شماره‌گیری'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('در حال شماره‌گیری $phone...')),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final attendance = Provider.of<AttendanceProvider>(context);
    final list = attendance.absenteesList;

    // Filter list
    final filtered = list.where((item) {
      if (_selectedFilter != 'all' && item['status'] != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final name = '${item['first_name']} ${item['last_name']}'.toLowerCase();
        if (!name.contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست غایبین و تأخیری‌های امروز'),
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'جستجوی نام دانش‌آموز...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('all', 'همه (${ShamsiHelper.toPersianDigits(list.length)})'),
                const SizedBox(width: 8),
                _buildFilterChip('absent_unexcused', 'غایب غیرموجه'),
                const SizedBox(width: 8),
                _buildFilterChip('absent_excused', 'غایب موجه'),
                const SizedBox(width: 8),
                _buildFilterChip('late', 'دارای تأخیر'),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Absentees List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_satisfied_alt_rounded, size: 56, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'موردی برای نمایش وجود ندارد.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final status = item['status'];
                      final studentName = '${item['first_name']} ${item['last_name']}';
                      final className = item['class_name'] ?? '';
                      final phone = item['parent_phone'] ?? '';
                      final notes = item['notes'];
                      final teacherName = item['teacher_name'] ?? 'معلم کلاس';

                      Color statusColor;
                      String statusText;
                      IconData statusIcon;

                      if (status == 'absent_unexcused') {
                        statusColor = const Color(0xFFFF7675);
                        statusText = 'غایب غیرموجه';
                        statusIcon = Icons.cancel;
                      } else if (status == 'absent_excused') {
                        statusColor = const Color(0xFF0984E3);
                        statusText = 'غایب موجه';
                        statusIcon = Icons.verified;
                      } else {
                        statusColor = const Color(0xFFE67E22);
                        statusText = 'تأخیر در ورود';
                        statusIcon = Icons.access_time;
                      }

                      return CustomCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: statusColor.withOpacity(0.12),
                                  child: Icon(statusIcon, color: statusColor, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        studentName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'کلاس $className  •  ثبت‌شده توسط: $teacherName',
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (notes != null && notes.toString().isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'توضیحات معلم: $notes',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                                ),
                              ),
                            ],
                            const SizedBox(height: 10),
                            const Divider(height: 1),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.phone_in_talk_outlined, size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      'شماره ولی: ${ShamsiHelper.toPersianDigits(phone)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.phone_forwarded, size: 16),
                                  label: const Text('تماس تلفنی', style: TextStyle(fontSize: 12)),
                                  onPressed: () => _callParent(phone, studentName),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF6C5CE7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedFilter = value;
          });
        }
      },
    );
  }
}
