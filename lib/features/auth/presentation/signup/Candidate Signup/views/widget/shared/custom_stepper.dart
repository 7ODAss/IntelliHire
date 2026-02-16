import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({super.key, required this.screenNumber});
  final int screenNumber;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (screenNumber >= index)
                    ? AppColor.primary
                    : Colors.transparent,
                border: Border.all(color: AppColor.primary, width: 2),
              ),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                child: Text('${index + 1}'),
              ),
            ),
            if (index != 2)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 80,
                height: 2,
                color: Colors.white,
              ),
          ],
        );
      }),
    );
  }
}
