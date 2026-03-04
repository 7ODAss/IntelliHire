import 'package:flutter/material.dart';

class OrganizationHomeView extends StatelessWidget {
  const OrganizationHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Home",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
