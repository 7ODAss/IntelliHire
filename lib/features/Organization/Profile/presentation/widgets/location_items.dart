import 'package:flutter/material.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../auth/presentation/login/widget/field_item.dart';
import '../../../../auth/presentation/signup/company/widget/custom_search.dart';
import '../controller/profile_cubit.dart';


class LocationItems extends StatefulWidget {
  final ProfileCubit cubit;
  final TextEditingController addressController;
  const LocationItems({super.key, required this.cubit, required this.addressController});

  @override
  State<LocationItems> createState() => _LocationItemsState();
}

class _LocationItemsState extends State<LocationItems> {
  late TextEditingController countryController ;
  late TextEditingController govController ;
  // late GlobalKey<FormState> locationFormKey;
  // late SearchController searchCountryController;
  // late SearchController searchGovController;

  @override
  void initState() {
    super.initState();
    countryController = TextEditingController();
    govController = TextEditingController();
    // locationFormKey = GlobalKey<FormState>();
    // searchCountryController = SearchController();
    // searchGovController = SearchController();
  }

  @override
  void dispose() {
    countryController.dispose();
    govController.dispose();
    super.dispose();
  }
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
                items: widget.cubit.countries,
                selectedItem: widget.cubit.state.selectedCountry,
                onSelected: (value) {
                  countryController.text = value;
                  widget.cubit.changeSelectedCountry(value);
                  widget.cubit.changeSelectedGovernorate('');
                  govController.clear();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SharedBottomSheetSelector(
                title: 'Select Governorate',
                hintText: 'Search...',
                items: widget.cubit.state.selectedCountry != null
                    ? (widget.cubit.countryGovernorates[widget.cubit
                    .state
                    .selectedCountry!] ??
                    [])
                    : [],
                selectedItem: widget.cubit.state.selectedGovernorate,
                // Use state value directly
                isEnabled: widget.cubit.state.selectedCountry != null,
                disabledMessage: 'Please select a country first',
                onSelected: (value) {
                  govController.text = value;
                  widget.cubit.changeSelectedGovernorate(value);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        FieldItem(
          controller: widget.addressController,
          title: 'Detailed Address',
          type: TextInputType.text,
          hintText: 'e.g. Building 4, Street 9, Maadi',
        ),
      ],
    );
  }
}
