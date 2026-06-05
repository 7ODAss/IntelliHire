import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class ExitAssessmentDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirmExit;

  const ExitAssessmentDialog({
    super.key,
    required this.onCancel,
    required this.onConfirmExit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 36,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Exit Assessment?',
              style: TextStyle(
                fontFamily: AppFont.interBold,
                fontSize: 18,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Are you sure you want to leave? All your current progress will be lost and you will have to start over.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFont.interRegular,
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: AppFont.interRegular,
                        fontSize: 14,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirmExit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Yes, Exit',
                      style: TextStyle(
                        fontFamily: AppFont.interRegular,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
