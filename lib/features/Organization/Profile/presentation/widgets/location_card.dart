import 'package:flutter/material.dart';

import '../controller/profile_cubit.dart';
import 'location_action.dart';
import 'location_items.dart';
import 'locations_list.dart';

class LocationCard extends StatefulWidget {
  final ProfileCubit cubit;
  final ProfileState state;

  const LocationCard({super.key, required this.cubit, required this.state});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  late TextEditingController addressController;
  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
  }

  @override
  void dispose() {

    super.dispose();
    addressController.dispose();
  }
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
            LocationItems(cubit: widget.cubit,addressController: addressController,),
            const SizedBox(height: 20),
            LocationAction(cubit: widget.cubit,addressController: addressController,),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            if (widget.state.locations != null)
              LocationsList(cubit: widget.cubit,state: widget.state,),
          ],
        ),
      ),
    );
  }
}
