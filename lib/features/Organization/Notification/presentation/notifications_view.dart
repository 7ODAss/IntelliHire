import 'package:flutter/material.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/widget/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 24),

                NotificationCard(
                  title: 'New Applicant',
                  description: 'Omar Osama applied for Backend Engineer',
                  time: '10m ago',
                  isUnread: true,
                ),
                const SizedBox(height: 16),

                NotificationCard(
                  title: 'New Applicant',
                  description: 'Mahmoud Magdy applied for Backend Engineer',
                  time: '10m ago',
                  isUnread: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
