import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/candidate/Notification/presentation/controller/NotificationCubit/CandidateNotificationCubit.dart';
import 'package:intelli_hire/features/candidate/Notification/presentation/controller/NotificationCubit/CandidateNotificationState.dart';
import 'package:intelli_hire/features/candidate/Notification/presentation/widget/notification_card.dart';

class CandidateNotificationsView extends StatefulWidget {
  const CandidateNotificationsView({super.key});

  @override
  State<CandidateNotificationsView> createState() =>
      _CandidateNotificationsViewState();
}

class _CandidateNotificationsViewState
    extends State<CandidateNotificationsView> {
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

              // 🌟 العنوان وجنبه زرار "مسح الكل" في Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  BlocBuilder<
                    CandidateNotificationcubit,
                    Candidatenotificationstate
                  >(
                    builder: (context, state) {
                      bool hasNotifications = false;
                      if (state is CandidateNotificationLoaded) {
                        hasNotifications = state.notifications.isNotEmpty;
                      }

                      if (!hasNotifications) {
                        return const SizedBox.shrink();
                      }

                      return TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: const Color(0xffF8FAFC),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text("Clear All Notifications?"),
                              content: const Text(
                                "Are you sure you want to delete all notifications? This action cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context
                                        .read<CandidateNotificationcubit>()
                                        .deleteAllNotificationsLocally();
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text(
                          "Clear All",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child:
                    BlocBuilder<
                      CandidateNotificationcubit,
                      Candidatenotificationstate
                    >(
                      builder: (context, state) {
                        if (state is CandidateNotificationLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is CandidateNotificationLoaded) {
                          // 🌟 شرط الشاشة الفاضية
                          if (state.notifications.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                context
                                    .read<CandidateNotificationcubit>()
                                    .fetchNotifications();
                              },
                              child: CustomScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              color: AppColor
                                                  .addLocationButtonBackGroundColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.notifications_off_outlined,
                                              size: 50,
                                              color: AppColor.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'No Notifications Yet',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'When you get notifications,\nthey will show up here.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // 🌟 شرط وجود إشعارات (تم تظبيط الأقواس هنا)
                          return RefreshIndicator(
                            onRefresh: () async {
                              context
                                  .read<CandidateNotificationcubit>()
                                  .fetchNotifications(isRefresh: true);
                            },
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: state.notifications.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final notification = state.notifications[index];

                                return Dismissible(
                                  key: Key(notification.id ?? index.toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    context
                                        .read<CandidateNotificationcubit>()
                                        .deleteNotificationLocally(
                                          notification.id ?? '',
                                        );
                                  },
                                  child: NotificationCard(
                                    title: notification.title ?? '',
                                    description: notification.description ?? '',
                                    time: notification.time ?? '',
                                    isRead: notification.isRead,
                                    onTap: () {},
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        if (state is CandidateNotificationError) {
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
