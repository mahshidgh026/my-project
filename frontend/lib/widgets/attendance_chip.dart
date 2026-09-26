import 'package:flutter/material.dart';

class AttendanceStatusSelector extends StatelessWidget {
  final String currentStatus;
  final Function(String) onStatusChanged;

  const AttendanceStatusSelector({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        _buildOption(
          label: 'حاضر',
          value: 'present',
          color: const Color(0xFF00B894),
          icon: Icons.check_circle_outline,
        ),
        _buildOption(
          label: 'غایب',
          value: 'absent_unexcused',
          color: const Color(0xFFFF7675),
          icon: Icons.cancel_outlined,
        ),
        _buildOption(
          label: 'موجه',
          value: 'absent_excused',
          color: const Color(0xFF0984E3),
          icon: Icons.verified_outlined,
        ),
        _buildOption(
          label: 'تأخیر',
          value: 'late',
          color: const Color(0xFFE67E22),
          icon: Icons.access_time,
        ),
      ],
    );
  }

  Widget _buildOption({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = currentStatus == value;
    return InkWell(
      onTap: () => onStatusChanged(value),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
