import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/Notification/presentation/candidate_notifications_view.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/screens/new_assess_screen.dart';
import 'package:intelli_hire/features/candidate/profile/presentation/profile_screen_candidate.dart';

import '../../../../core/helpers/cache_helper.dart';
import '../../../../core/utils/app_color.dart';
import '../../../Organization/bottom _navigation/presentation/widget/nav_item.dart';
import '../../assess manage/presentation/assess_manage_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../new assess/presentation/screens/interview_question_screen.dart';
import '../controller/bottom_nav_candidate_cubit.dart';

import 'package:intelli_hire/features/candidate/Notification/presentation/controller/NotificationCubit/CandidateNotificationCubit.dart';
import 'package:intelli_hire/features/candidate/Notification/presentation/controller/NotificationCubit/CandidateNotificationState.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  static CustomBottomNavBarState? of(BuildContext context) {
    return context.findAncestorStateOfType<CustomBottomNavBarState>();
  }

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
    const HomeScreen(),
    const AssessManageScreen(),
    const CandidateNotificationsView(),
    const ProfileScreenCandidate(),
  ];

  Future<bool> showAgain() async {
    String? showVal = await CacheHelper.getData(key: 'do_not_show');
    return showVal == 'true';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCandidateCubit, BottomNavCandidateState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: state.index,
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
          floatingActionButton: state.index != 3
              ? SizedBox(
                  width: 60,
                  height: 60,
                  child: FloatingActionButton(
                    onPressed: () async {
                      bool skipInstructions = await showAgain();
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => skipInstructions
                              ? InterviewQuestionScreen(
                                  assessmentId: 'assess_123',
                                  title: 'Software Engineer',
                                  track: 'Flutter Development',
                                )
                              : const NewAssessScreen(
                                  assessmentId: 'assess_123',
                                  title: 'Software Engineer',
                                  track: 'Flutter Development',
                                ),
                        ),
                      );
                    },
                    backgroundColor: AppColor.primary,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add, size: 36, color: Colors.white),
                  ),
                )
              : null,
          bottomNavigationBar: state.index != 3
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
                            onPressed: () => _onNavItemTapped(0, state.index),
                            isActive: state.index == 0,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconPath: "assets/image/icon svg/electric.svg",
                            height: 22,
                            onPressed: () => _onNavItemTapped(1, state.index),
                            isActive: state.index == 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          BlocBuilder<CandidateNotificationcubit, Candidatenotificationstate>(
                            builder: (context, notifState) {
                              int unreadCount = 0;
                              if (notifState is CandidateNotificationLoaded) {
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
                                      // 🌟 مش بنقرا هنا خالص! بنفتح الصفحة بس!
                                      _onNavItemTapped(2, state.index);
                                    },
                                    isActive: state.index == 2,
                                  ),
                                  // 🌟 النقطة الحمرا بتختفي لوحدها لو دخلت الصفحة
                                  if (unreadCount > 0 && state.index != 2)
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
                            isActive: state.index == 3,
                            onPressed: () => _onNavItemTapped(3, state.index),
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
      // 🌟 السحر كله هنا: أول ما تخرج من صفحة الإشعارات (index 2) لأي صفحة تانية، علمهم كمقروء!
      if (currentIndex == 2) {
        context.read<CandidateNotificationcubit>().markAllAsRead();
      }
      context.read<BottomNavCandidateCubit>().changeIndex(tappedIndex);
    }
  }
}