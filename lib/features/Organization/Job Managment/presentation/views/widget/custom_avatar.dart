import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class CustomAvatar extends StatelessWidget {
  const CustomAvatar({
    super.key,
    required this.name,
    required this.height,
    required this.width,
  });

  final String name;
  final double height;
  final double width;

  String _getInitials(String fullName) {
    final trimmedName = fullName.trim();
    
    if (trimmedName.isEmpty) return " "; 

    final nameParts = trimmedName.split(" ");
    
    if (nameParts.length == 1) {
      return trimmedName[0].toUpperCase();
    } else {
      return (nameParts.first[0] + nameParts.last[0]).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xffD6D6D6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _getInitials(name), 
          style: AppTextStyle.textstyle20.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}