import 'package:flutter/material.dart';

import '../../../../../core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/shared/get_initials.dart';

class CompanyProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;

  const CompanyProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
  });

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
                shape: BoxShape.circle,
                image: (imageUrl != null && imageUrl!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? Center(
                      child: Text(
                        GetInitials.getInitials(name),
                        style: AppTextStyle.iconNamePostScreen,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
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
