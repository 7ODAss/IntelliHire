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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: fun,
        borderRadius: BorderRadius.circular(
          12,
        ), // 🌟 عشان اللمعة تلتزم بحواف الزرار
        splashColor: Colors.black12, // 🌟 لون اللمعة لما تدوس
        highlightColor: Colors.black.withOpacity(0.05), // 🌟 تأثير الضغط المطول
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFF1F1F1),
                radius: 25,
                child: Icon(icon, color: Color(0xFFD6D6D6), size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
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
              ),
              Icon(Icons.arrow_forward_ios_outlined, color: Color(0xFF94A3B8)),
            ],
          ),
        ),
      ),
    );
  }
}
