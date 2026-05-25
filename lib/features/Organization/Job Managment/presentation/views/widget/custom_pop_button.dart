import 'package:flutter/material.dart';

class CustomPopButton extends StatelessWidget {
  const CustomPopButton({super.key, this.onTap});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap ?? () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffF8FAFC),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0xffAFAFAF),
                  blurRadius: 5.6,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.arrow_back, color: Color(0xff141414), size: 20),
            ),
          ),
        ),
      ],
    );
  }
}
