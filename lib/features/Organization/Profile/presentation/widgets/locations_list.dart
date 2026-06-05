import 'package:flutter/material.dart';
import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../controller/profile_cubit.dart';

class LocationsList extends StatelessWidget {
  final ProfileCubit cubit;
  final ProfileState state;
  const LocationsList({super.key, required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final base = cubit.state.locations![index];
        return ListTile(
          titleAlignment:
          ListTileTitleAlignment.titleHeight,
          tileColor: const Color(0xFFF8FAFC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),

          leading: const Icon(
            Icons.location_on,
            color: Color(0xFF0F172A),
            size: 24,
          ),
          title: Text(
            '${base.governorate}, ${base.country}',
            style: AppTextStyle.fieldTitleStyle
                .copyWith(
              fontSize: 14,
              color:
              AppColor.titlePostScreenColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              base.address,
              style: AppTextStyle.fieldTitleStyle
                  .copyWith(fontSize: 16),
            ),
          ),

          trailing: Column(
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(
                  Icons.close,
                  color: Color(0xFFDC2626),
                  size: 20,
                ),
                onPressed: () => cubit
                    .removeCompanyLocation(index),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) =>
      const SizedBox(height: 12),
      itemCount: state.locations!.length,
    );
  }
}
