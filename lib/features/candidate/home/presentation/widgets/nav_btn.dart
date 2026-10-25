import 'package:flutter/material.dart';

class NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const NavBtn({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 37,
        height: 37,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.09),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.22), width: 1),
        ),
        child: Center(
          child: Icon(
            icon,
            color: enabled ? Colors.white : Colors.white24,
            size: 20,
          ),
        ),
      ),
    );
  }
}
