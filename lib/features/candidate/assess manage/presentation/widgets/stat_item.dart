import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/utils/app_font.dart';

class StatItem extends StatelessWidget {
  final String label, value;
  const StatItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Skeleton.replace(
          replacement: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white10, // لون البوكس وقت التحميل
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          child: Row(
            children: [
              Text(
                '$label : ',
                style: const TextStyle(
                  fontFamily: AppFont.interBold,
                  fontSize: 16,
                  color: Colors.white60,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: AppFont.interBold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
