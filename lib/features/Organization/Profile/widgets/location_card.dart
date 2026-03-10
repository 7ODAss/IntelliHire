import 'package:flutter/material.dart';

import '../controller/profile_cubit.dart';
import 'location_action.dart';
import 'location_items.dart';
import 'locations_list.dart';

class LocationCard extends StatelessWidget {
  final ProfileCubit cubit;
  final ProfileState state;
  const LocationCard({super.key, required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    return  Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationItems(cubit: cubit,),
            const SizedBox(height: 20),
            LocationAction(cubit: cubit,),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            if (state.locations != null)
              LocationsList(cubit: cubit,state: state,),
          ],
        ),
      ),
    );
  }
}
