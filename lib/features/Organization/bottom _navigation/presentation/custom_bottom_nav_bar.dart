import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/views/job_management_view.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/notifications_view.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/organization_home_view.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/profile_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/post_job_view.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/widget/nav_item.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_cubit.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/controller/NotificationCubit/notification_state.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => CustomBottomNavBarState();
}

class CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> rootScreens = [
    const OrganizationHomeView(),
    const JobManagementView(),
    const NotificationsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, navState) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: navState.index,
            children: List.generate(rootScreens.length, (index) {
              return Navigator(
                key: navigatorKeys[index],
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(builder: (_) => rootScreens[index]);
                },
              );
            }),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: navState.index != 3
              ? SizedBox(
                  width: 60,
                  height: 60,
                  child: FloatingActionButton(
                    onPressed: () => _goToPostJob(context),
                    backgroundColor: AppColor.primary,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, size: 36, color: Colors.white),
                  ),
                )
              : null,
          bottomNavigationBar: navState.index != 3
              ? BottomAppBar(
                  shape: const CircularNotchedRectangle(),
                  notchMargin: 10,
                  color: AppColor.darkBlue,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          NavItem(
                            iconPath: "assets/image/icon svg/home.svg",
                            height: 26,
                            onPressed: () =>
                                _onNavItemTapped(0, navState.index),
                            isActive: navState.index == 0,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconPath: "assets/image/icon svg/suitcase.svg",
                            height: 22,
                            onPressed: () =>
                                _onNavItemTapped(1, navState.index),
                            isActive: navState.index == 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // 🌟 الجرس مع الـ Badge
                          BlocBuilder<NotificationCubit, NotificationState>(
                            builder: (context, notifState) {
                              int unreadCount = 0;
                              if (notifState is NotificationLoaded) {
                                unreadCount = notifState.notifications
                                    .where((n) => n.isRead == false)
                                    .length;
                              }

                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  NavItem(
                                    iconPath: "assets/image/icon svg/bell.svg",
                                    onPressed: () {
                                      // 🌟 بنفتح الصفحة بس من غير ما نبعت أمر الـ markAllAsRead
                                      _onNavItemTapped(2, navState.index);
                                    },
                                    isActive: navState.index == 2,
                                  ),
                                  // 🌟 النقطة بتختفي لوحدها طول ما إحنا جوة صفحة الإشعارات
                                  if (unreadCount > 0 && navState.index != 2)
                                    Positioned(
                                      right: 0,
                                      top: -5,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 18,
                                          minHeight: 18,
                                        ),
                                        child: Text(
                                          '$unreadCount',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconPath: "assets/image/icon svg/profile.svg",
                            isActive: navState.index == 3,
                            onPressed: () =>
                                _onNavItemTapped(3, navState.index),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : null,
        );
      },
    );
  }

  void _onNavItemTapped(int tappedIndex, int currentIndex) {
    if (currentIndex == tappedIndex) {
      navigatorKeys[tappedIndex].currentState!.popUntil(
        (route) => route.isFirst,
      );
    } else {
      if (currentIndex == 2) {
        context.read<NotificationCubit>().markAllAsRead();
      }
      context.read<BottomNavCubit>().changeIndex(tappedIndex);
    }
  }

  void _goToPostJob(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PostJobCubit>()),
            BlocProvider.value(value: context.read<JobManagementCubit>()),
            BlocProvider.value(value: context.read<BottomNavCubit>()),
          ],
          child: const PostJobView(),
        ),
      ),
    );
  }
}