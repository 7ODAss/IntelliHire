import 'package:flutter/material.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/current_job_card.dart';

class CurrentJobListView extends StatelessWidget {
  const CurrentJobListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, n) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 24),
            child: CurrentJobCard(),
          );
        },
      ),
    );
  }
}
