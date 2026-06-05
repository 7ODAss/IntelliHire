import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const SkillChip({super.key, required this.label, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFB9C2FD).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyle.textstyle12.copyWith(color: Color(0XFF475569)),
          ),
          const SizedBox(width: 8.0),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(
              Icons.close_rounded,
              color: Color(0XFFDC2626),
              size: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
