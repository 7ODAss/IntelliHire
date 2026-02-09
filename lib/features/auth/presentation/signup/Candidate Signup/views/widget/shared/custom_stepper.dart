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
        final isActive = index == screenNumber;
        return Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColor.primary : Colors.transparent,
                border: Border.all(color: AppColor.primary, width: 2),
              ),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.blue,
                  fontSize: 8,
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
