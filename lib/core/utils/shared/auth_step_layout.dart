import 'package:flutter/material.dart';

class AuthStepLayout extends StatelessWidget {
  final Widget child;
  final bool isHeader;
  final double? height;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;

  const AuthStepLayout({
    super.key,
    required this.child,
    this.isHeader = false,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final defaultHeight = isHeader ? screenHeight * 0.25 : screenHeight * 0.75;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.5, 0.5, 1.0],
          colors: [
            Colors.white,
            Colors.white,
            Color(0xFF0F172A),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Container(
        height: height ?? defaultHeight,
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? (isHeader ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
          borderRadius: borderRadius ?? (isHeader 
            ? const BorderRadius.only(bottomLeft: Radius.circular(60))
            : const BorderRadius.only(topRight: Radius.circular(60))),
        ),
        child: child,
      ),
    );
  }
}
