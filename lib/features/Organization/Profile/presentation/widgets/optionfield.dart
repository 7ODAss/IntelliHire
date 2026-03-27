import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_style.dart';

class OptionField extends StatelessWidget {
  final IconData icon;
  final String categoryName;
  final List<String> options;
  final void Function()? fun;

  const OptionField({
    super.key,
    required this.icon,
    required this.categoryName,
    required this.options,
    this.fun,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: fun,
          child: Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFFF1F1F1),
                  radius: 25,
                  child: Icon(icon, color: Color(0xFFD6D6D6), size: 30),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryName,
                      style: AppTextStyle.accountNamePostScreen.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                     options.join(' , '),
                      style: AppTextStyle.accountSubNamePostScreen.copyWith(
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
