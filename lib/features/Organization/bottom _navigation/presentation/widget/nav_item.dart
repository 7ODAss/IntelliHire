import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intelli_hire/core/utils/app_color.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.iconPath,
    this.height,
    required this.onPressed,
    required this.isActive,
  });

  final String iconPath;
  final double? height;
  final void Function() onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: height ?? 24,
        colorFilter: ColorFilter.mode(
          isActive ? AppColor.primary : Colors.white,
          BlendMode.srcIn,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
