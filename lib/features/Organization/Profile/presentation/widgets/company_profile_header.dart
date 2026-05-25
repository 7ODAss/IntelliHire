import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/get_initials.dart';

class CompanyProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  const CompanyProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Column(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColor.iconProfileColor,
                border: Border.all(
                  color: AppColor.iconProfileBorderColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(150)),
              ),
              child: Center(
                child: Text(
                  GetInitials.getInitials(name),
                  style: AppTextStyle.iconNamePostScreen,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              name,
              style: AppTextStyle.accountNamePostScreen,
            ),
            Text(
              email,
              style: AppTextStyle.accountSubNamePostScreen,
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}
