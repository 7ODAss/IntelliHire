import 'package:flutter/material.dart';
import '../../../../../core/utils/app_font.dart';

class DateGlassCard extends StatelessWidget {
  final double dynamicWidth;
  final String weekLabel;

  const DateGlassCard({
    super.key,
    required this.dynamicWidth,
    required this.weekLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dynamicWidth,
      height: 37,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: weekLabel.split(',')[0],
                style: const TextStyle(
                  fontFamily: AppFont.interSemiBold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: weekLabel.split(',')[1],
                style: const TextStyle(
                  fontFamily: AppFont.interSemiBold,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
