import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../auth/presentation/login/widget/field_item.dart';
import '../../../../auth/presentation/signup/widget/custom_search.dart';
import '../controller/profile_cubit.dart';


class LocationItems extends StatelessWidget {
  final ProfileCubit cubit;
  const LocationItems({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location', style: AppTextStyle.fieldTitleStyle),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: SharedBottomSheetSelector(
                title: 'Select Country',
                hintText: 'Search...',
                items: cubit.countries,
                selectedItem: cubit.state.selectedCountry,
                onSelected: (value) {
                  cubit.countryController.text = value;
                  cubit.changeSelectedCountry(value);
                  cubit.changeSelectedGovernorate('');
                  cubit.govController.clear();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SharedBottomSheetSelector(
                title: 'Select Governorate',
                hintText: 'Search...',
                items: cubit.state.selectedCountry != null
                    ? (cubit.countryGovernorates[cubit
                    .state
                    .selectedCountry!] ??
                    [])
                    : [],
                selectedItem: cubit.state.selectedGovernorate,
                // Use state value directly
                isEnabled: cubit.state.selectedCountry != null,
                disabledMessage: 'Please select a country first',
                onSelected: (value) {
                  cubit.govController.text = value;
                  cubit.changeSelectedGovernorate(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        FieldItem(
          controller: cubit.addressController,
          title: 'Detailed Address',
          type: TextInputType.text,
          hintText: 'Building 4 , Street 9 , Maadi',
        ),
      ],
    );
  }
}
