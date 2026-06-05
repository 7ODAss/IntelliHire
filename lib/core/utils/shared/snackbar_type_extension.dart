import 'package:flutter/material.dart';
import 'package:intelli_hire/core/enums/snack_bar_type.dart';

extension SnackbarTypeExtension on SnackBarType {
  Color get backgroundColor {
    switch (this) {
      case SnackBarType.success:
        return Colors.green; // Green
      case SnackBarType.error:
        return Colors.red; //  Red

    }
  }
}
