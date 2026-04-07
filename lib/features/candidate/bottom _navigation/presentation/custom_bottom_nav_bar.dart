import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/screens/new_assess_screen.dart';
import '../../../../core/utils/app_color.dart';
import '../../../Organization/bottom _navigation/presentation/widget/nav_item.dart';
import '../../assess manage/presentation/assess_manage_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../notification/presentation/notification_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../controller/bottom_nav_candidate_cubit.dart';

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
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCandidateCubit, BottomNavCandidateState>(
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
                          builder: (newContext) => const NewAssessScreen(),
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
                            iconPath:
                                "assets/image/bottom nav icon svg/home.svg",
                            height: 26,
                            onPressed: () => _onNavItemTapped(0, state.index),
                            isActive: state.index == 0,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconPath:
                                "assets/image/bottom nav icon svg/electric.svg",
                            height: 22,
                            onPressed: () => _onNavItemTapped(1, state.index),
                            isActive: state.index == 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          NavItem(
                            iconPath:
                                "assets/image/bottom nav icon svg/bell.svg",
                            onPressed: () => _onNavItemTapped(2, state.index),
                            isActive: state.index == 2,
                          ),
                          const SizedBox(width: 32),
                          NavItem(
                            iconPath:
                                "assets/image/bottom nav icon svg/profile.svg",
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
      context.read<BottomNavCandidateCubit>().changeIndex(tappedIndex);
    }
  }
}
