import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final String message;

  const ErrorMessageModel({required this.message});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    // Check for "message" key directly first, as it's common in your backend responses
    if (json['message'] != null && json['message'].toString().isNotEmpty) {
      return ErrorMessageModel(message: json['message'].toString());
    }

    // Check for "errors" map (common in validation errors)
    final errors = json['errors'] as Map<String, dynamic>?;
    if (errors != null && errors.isNotEmpty) {
      return ErrorMessageModel(
        message: errors.entries.first.value.toString(),
      );
    }

    return const ErrorMessageModel(
      message: 'An unknown error occurred. Please try again.',
    );
  }

  @override
  List<Object?> get props => [message];
}
