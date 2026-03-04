import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_font.dart';

class PostJobStepper extends StatelessWidget {
  const PostJobStepper({super.key, required this.screenNumber});
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
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (screenNumber >= index)
                    ? AppColor.signUpConditionColor2
                    : Colors.transparent,
                border: Border.all(
                  color: AppColor.signUpConditionColor2,
                  width: 1,
                ),
              ),
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: (screenNumber >= index)
                      ? Colors.white
                      : Color(0xff475569),
                  fontSize: 8,
                  fontFamily: AppFont.interRegular,
                  fontWeight: FontWeight.w400,
                ),
                child: Text('${index + 1}'),
              ),
            ),
            if (index != 2)
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 50,
                height: 1,
                color: Color(0xffEAEDFE),
              ),
          ],
        );
      }),
    );
  }
}
