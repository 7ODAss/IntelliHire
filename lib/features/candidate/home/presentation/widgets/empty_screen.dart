import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.50,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.rocket_launch_outlined,
                size: 65,
                color: Color(0xFF1D4ED8),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome to IntelliHire!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800, // Bold جداً زي التصميم
              color: Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'You haven\'t taken any assessments yet\nStart your first assessment and let our AI\nevaluate your skills.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF64748B), // لون رمادي عشان يطابق التصميم
                height: 1.5, // مسافة بين السطور عشان تكون مريحة للعين
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}