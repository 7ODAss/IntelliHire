import 'package:flutter/material.dart';

import '../../../../../core/utils/app_font.dart';

class CornerInterviewCard extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final double width;
  final double height;

  const CornerInterviewCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 26),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: const TextStyle(
                  fontFamily: AppFont.poppinsBold,
                  fontSize: 18,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppFont.interRegular,
                  fontSize: 11,
                  color: Color(0xFF8A94A6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}