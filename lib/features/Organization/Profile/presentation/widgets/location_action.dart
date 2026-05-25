import 'package:flutter/material.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../controller/profile_cubit.dart';

class LocationAction extends StatelessWidget {
  final ProfileCubit cubit;
  final TextEditingController addressController;
  const LocationAction({super.key, required this.cubit, required this.addressController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        cubit.addCompanyLocation(detailedAddress: addressController.text);
        addressController.clear();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
        AppColor.addLocationButtonBackGroundColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            color: AppColor.addLocationButtonTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            'Add Location',
            style: AppTextStyle.fieldTitleStyle
                .copyWith(
              color: AppColor
                  .addLocationButtonTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
