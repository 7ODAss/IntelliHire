import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/job_management_view.dart';
import 'package:intelli_hire/features/Organization/Notification/presentation/notifications_view.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/organization_home_view.dart';
import 'package:intelli_hire/features/Organization/Profile/presentation/profile_view.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/post_job_view.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/presentation/widget/nav_item.dart';

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
    const OrganizationHomeView(),
    const JobManagementView(),
    const NotificationsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (newContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: context.read<PostJobCubit>(),
                              ),
                              BlocProvider.value(
                                value: context.read<JobManagementCubit>(),
                              ),
                            ],
                            child: const PostJobView(),
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
                            iconPath: "assets/image/icon svg/suitcase.svg",
                            height: 22,
                            onPressed: () => _onNavItemTapped(1, state.index),
                            isActive: state.index == 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          NavItem(
                            iconPath: "assets/image/icon svg/bell.svg",
                            onPressed: () => _onNavItemTapped(2, state.index),
                            isActive: state.index == 2,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconPath:
                                "assets/image/icon svg/profile.svg",
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
      context.read<BottomNavCubit>().changeIndex(tappedIndex);
    }
  }
}
