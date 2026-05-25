import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class PostJobChoiceChip extends StatelessWidget {
  const PostJobChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      // 🌟 غلفنا النص بـ FittedBox عشان يصغر أوتوماتيك لو الشاشة ضيقة
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: AppTextStyle.textstyle12.copyWith(
            color: isSelected ? Colors.white : AppColor.darkBlue,
          ),
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColor.primary,
      backgroundColor: Colors.white,
      showCheckmark: false,
      // 🌟 قللنا الـ padding الأفقي من 16 لـ 8 عشان نوفر مساحة
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColor.primary : Colors.grey.shade300,
        ),
      ),
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
