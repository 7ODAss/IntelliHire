import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart'; // تأكد من المسار ده

class CompanyPhotoPicker2 extends StatefulWidget {
  final void Function(File? image) onImageSelected;
  final String initials;
  final String? imageUrl;

  const CompanyPhotoPicker2({
    super.key,
    required this.onImageSelected,
    this.initials = 'Tc',
    this.imageUrl,
  });

  @override
  State<CompanyPhotoPicker2> createState() => _CompanyPhotoPickerState();
}

class _CompanyPhotoPickerState extends State<CompanyPhotoPicker2> {
  File? _image;
  bool _isImageDeleted = false;

  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;
    setState(() {
      _isPicking = true;
    });
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isImageDeleted = false;
        });
        widget.onImageSelected(_image!);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }
  void _deleteImage() {
    setState(() {
      _image = null;
      _isImageDeleted = true;
    });
    widget.onImageSelected(null);
  }


  @override
  Widget build(BuildContext context) {
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
                  image: _image != null
                      ? DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  )
                      : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty && !_isImageDeleted)
                          ? DecorationImage(
                        image: NetworkImage(widget.imageUrl!),
                        fit: BoxFit.cover,
                      )
                          : null,
                ),
                child: (_image == null && (widget.imageUrl == null || widget.imageUrl!.isEmpty || _isImageDeleted))
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
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              if (_image != null || (widget.imageUrl != null && widget.imageUrl!.isNotEmpty && !_isImageDeleted))
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _deleteImage,
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColor.iconProfile2BorderColor,
                    child: Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
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