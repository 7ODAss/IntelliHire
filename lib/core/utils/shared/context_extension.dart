import 'package:flutter/material.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';
import 'package:intelli_hire/core/utils/shared/snackbar_type_extension.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.success,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: type.backgroundColor,
        margin: EdgeInsets.all(15),
        behavior: SnackBarBehavior.floating,
        elevation: 5,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
