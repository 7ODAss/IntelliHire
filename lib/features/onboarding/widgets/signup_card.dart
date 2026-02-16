import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/app_color.dart';
import '../../../core/utils/app_icon.dart';
import '../../../core/utils/app_text_style.dart';

class SignupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final Color color;
  final void Function()? opTap;

  const SignupCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.opTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: opTap,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              SvgPicture.asset(icon),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.landingTitleStyle.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(subtitle, style: AppTextStyle.subTitleStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
