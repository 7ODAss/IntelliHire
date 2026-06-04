import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart'; // 🌟 الـ import الجديد للكاش
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class CandidatePhotoPicker extends StatefulWidget {
  final void Function(File image) onImageSelected;
  final String initials;
  final String? imageUrl;

  const CandidatePhotoPicker({
    super.key,
    required this.onImageSelected,
    required this.initials,
    this.imageUrl,
  });

  @override
  State<CandidatePhotoPicker> createState() => _CandidatePhotoPickerState();
}

class _CandidatePhotoPickerState extends State<CandidatePhotoPicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      widget.onImageSelected(_image!);
    }
    print('image: $_image');
  }

  DecorationImage? _getDecorationImage() {
    if (_image != null) {
      return DecorationImage(image: FileImage(_image!), fit: BoxFit.cover);
    } else if (widget.imageUrl != null && widget.imageUrl!.trim().isNotEmpty) {
      return DecorationImage(
        image: CachedNetworkImageProvider(widget.imageUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool showInitials =
        _image == null &&
        (widget.imageUrl == null || widget.imageUrl!.trim().isEmpty);

    return GestureDetector(
      onTap: _pickImage,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
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
                  image: _getDecorationImage(),
                ),
                child: showInitials
                    ? Center(
                        child: Text(
                          widget.initials,
                          style: AppTextStyle.iconNamePostScreen,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColor.iconProfileBorderColor,
                    child: Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
