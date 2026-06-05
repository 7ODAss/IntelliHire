import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_font.dart';

class Header extends StatelessWidget {
  final String userName;

  const Header({super.key,required this.userName});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  Widget build(BuildContext context) {
    print('header build');
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back ,',
                  style: TextStyle(
                    fontFamily: AppFont.interRegular,
                    fontSize: 13,
                    color: Color(0xFF8A94A6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: const TextStyle(
                    fontFamily: AppFont.poppinsBold,
                    fontSize: 22,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primary.withOpacity(0.12),
                border: Border.all(
                  color: AppColor.primary.withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  _initials(userName),
                  style: TextStyle(
                    fontFamily: AppFont.interBold,
                    fontSize: 14,
                    color: AppColor.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}