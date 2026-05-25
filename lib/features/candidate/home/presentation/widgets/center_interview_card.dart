import 'package:flutter/material.dart';

import '../../../../../core/utils/app_font.dart';

class CenterInterviewCard extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color iconColor;


  const CenterInterviewCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,

  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12),
      child: Container(

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 26),
              Column(
                children: [
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
                      fontSize: 12,
                      color: Color(0xFF8A94A6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}