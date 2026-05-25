import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_cubit.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_state.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/widget/notification_card.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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

              Expanded(
                child: BlocBuilder<NotificationCubit, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is NotificationLoaded) {
                      if (state.notifications.isEmpty) {
                        return const Center(
                          child: Text('No notifications yet.'),
                        );
                      }

                      return ListView.separated(
                        itemCount: state.notifications.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final notification = state.notifications[index];
                          return NotificationCard(
                            title: notification.title,
                            description: notification.description,
                            time: notification.time,
                            isUnread: notification.isUnread,
                            // 🔴 ضفنا الأكشن هنا
                            onTap: () {
                              if (notification.isUnread) {
   
                                context.read<NotificationCubit>().markNotificationAsRead(notification.id);
                              }

                              // 💡 وممكن كمان تعمل Navigation هنا!
                              // يعني لو النوتيفيكيشن عن متقدم جديد، توديه لصفحة الـ Applicants
                            },
                          );
                        },
                      );
                    } else if (state is NotificationError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
