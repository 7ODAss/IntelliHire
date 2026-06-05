import 'package:flutter/material.dart';
import '../controller/profile_cubit.dart';
import 'location_items.dart';

class LocationCard extends StatelessWidget {
  final ProfileCubit cubit;
  final ProfileState state;
  final TextEditingController addressController;

  const LocationCard({
    super.key,
    required this.cubit,
    required this.state,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationItems(
              cubit: cubit,
              addressController: addressController,
            ),
          ],
        ),
      ),
    );
  }
}
