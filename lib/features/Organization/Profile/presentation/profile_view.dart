import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<BottomNavCubit>().goBackToPrevious();
              },
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
