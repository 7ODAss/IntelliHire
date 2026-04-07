import 'package:flutter/material.dart';

class AuthLayout extends StatelessWidget {
  final Widget headerContent;
  final Widget bodyContent;
  final Color bodyColor;
  final bool scrollableBody;

  const AuthLayout({
    super.key,
    required this.headerContent,
    required this.bodyContent,
    this.bodyColor = Colors.white,
    this.scrollableBody = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.5, 0.5, 1.0],
          colors: [
            Colors.white,
            Colors.white,
            Color(0xFF0F172A), // Use a constant from AppColor if available
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: SingleChildScrollView(
        // ClampingScrollPhysics handles the keyboard popping up better
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // Header Section (25% height)
            Container(
              height: screenHeight * 0.25,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF0F172A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: headerContent,
            ),
            // Body Section (75% height)
            Container(
              constraints: BoxConstraints(
                minHeight: screenHeight * 0.75,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: bodyColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(60),
                ),
              ),
              child: bodyContent,
            ),
          ],
        ),
      ),
    );
  }
}