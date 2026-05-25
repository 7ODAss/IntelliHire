import 'package:flutter/material.dart';

import '../../../../../core/utils/app_font.dart';

class AnswerBubble extends StatelessWidget {
  final String text;
  final bool isCandidate;

  const AnswerBubble({
    super.key,
    required this.text,
    required this.isCandidate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCandidate ? const Color(0xFFF8FAFC) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCandidate
              ? const Color(0xFFD8D5D6)
              : const Color(0xFFB9C2FD),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppFont.interRegular,
          fontSize: 18,
          color: Colors.black,
          height: 1.5,
        ),
      ),
    );
  }
}
