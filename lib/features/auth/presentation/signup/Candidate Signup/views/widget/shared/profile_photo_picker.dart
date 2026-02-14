import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:intelli_hire/core/utils/app_color.dart';

class ProfilePhotoPicker extends StatefulWidget {
  const ProfilePhotoPicker({super.key, this.radius = 60});

  final double radius;

  @override
  State<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            DottedBorder(
              options: CircularDottedBorderOptions(
                dashPattern: [5, 2],
                color: Color(0xff426FF9),
                strokeWidth: 1,
              ),
              child: CircleAvatar(
                radius: 75,
                backgroundColor: Colors.transparent,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.person, size: 85, color: AppColor.grey)
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
