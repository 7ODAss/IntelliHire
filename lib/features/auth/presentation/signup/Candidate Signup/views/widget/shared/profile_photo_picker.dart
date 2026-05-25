import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/features/auth/controller/profile%20setup%20cubit/profile_setup_cubit.dart';

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({super.key, this.radius = 60});

  final double radius;

  @override
  Widget build(BuildContext context) {
    final selectedImage = context.watch<ProfileSetupCubit>().selectedImage;

    return GestureDetector(
      onTap: () {
        context.read<ProfileSetupCubit>().pickImage();
      },
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            DottedBorder(
              options: const CircularDottedBorderOptions(
                dashPattern: [5, 2],
                color: Color(0xff426FF9),
                strokeWidth: 1,
              ),
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.transparent,
                backgroundImage: selectedImage != null ? FileImage(selectedImage) : null,
                child: selectedImage == null
                    ? const Icon(Icons.person, size: 85, color: AppColor.grey)
                    : null,
              ),
            ),
            Positioned(
              bottom: 2,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff0F172A),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                padding: const EdgeInsets.all(2),
                child: const Icon(Icons.add, size: 16, color: AppColor.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}