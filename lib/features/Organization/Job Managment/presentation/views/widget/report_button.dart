import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class ReportButton extends StatelessWidget {
  const ReportButton({
    super.key,
    this.icon,
    required this.label,
    this.text,
    this.onPressed,
  });

  final String? icon;
  final String label;
  final String? text;
  final VoidCallback? onPressed;

  @override
 @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        // قللنا البادينج شوية عشان ندي مساحة للنص
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), 
        side: const BorderSide(
          color: Color(0xff475569),
          width: 1.0,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      // ضفنا FittedBox هنا عشان يصغر المحتوى تلقائي لو الشاشة ضيقة
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text != null && text!.isNotEmpty) ...[
              Text(
                text!,
                style: AppTextStyle.textstyle12.copyWith(
                  color: const Color(0xff475569),
                ),
              ),
              const SizedBox(width: 6),
            ] else if (icon != null) ...[
              SvgPicture.asset(
                icon!,
                colorFilter: const ColorFilter.mode(
                  Color(0xff475569),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
            ],
            
            Text(
              label,
              style: AppTextStyle.textstyle12.copyWith(color: const Color(0xff475569)),
            ),
          ],
        ),
      ),
    );
  
  }
}
