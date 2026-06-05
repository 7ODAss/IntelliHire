import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intelli_hire/core/service/api_service.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class CustomAvatar extends StatefulWidget {
  const CustomAvatar({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    this.photoUrl,
  });

  final String name;
  final double height;
  final double width;
  final String? photoUrl;

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  Uint8List? _imageBytes;
  bool _isLoading = false;
  String? _loadedUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CustomAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrl != widget.photoUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    String? url = widget.photoUrl;
    if (url == null || url.isEmpty) {
      if (mounted) {
        setState(() {
          _imageBytes = null;
          _loadedUrl = null;
        });
      }
      return;
    }

    if (!url.startsWith('http')) {
      if (url.startsWith('/')) {
        url = "https://intellhire.runasp.net$url";
      } else {
        url = "https://intellhire.runasp.net/$url";
      }
    }

    if (_loadedUrl == url) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
        _imageBytes = null;
        _loadedUrl = url;
      });
    }

    try {
      final apiService = getIt<ApiService>();
      final response = await apiService.dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data != null && mounted) {
        setState(() {
          _imageBytes = Uint8List.fromList(response.data!);
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error downloading avatar image from $url: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getInitials(String fullName) {
    final trimmedName = fullName.trim();
    
    if (trimmedName.isEmpty) return " "; 

    final nameParts = trimmedName.split(" ");
    
    if (nameParts.length == 1) {
      return trimmedName[0].toUpperCase();
    } else {
      return (nameParts.first[0] + nameParts.last[0]).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget;

    if (_imageBytes != null) {
      childWidget = Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
        width: widget.width,
        height: widget.height,
      );
    } else if (_isLoading) {
      childWidget = const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    } else {
      childWidget = Center(
        child: Text(
          _getInitials(widget.name), 
          style: AppTextStyle.textstyle20.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w600,
            fontSize: widget.width * 0.3,
          ),
        ),
      );
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: const BoxDecoration(
        color: Color(0xffD6D6D6),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: childWidget,
    );
  }
}