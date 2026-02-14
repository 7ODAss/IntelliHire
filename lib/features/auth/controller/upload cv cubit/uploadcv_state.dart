import 'dart:io';

abstract class UploadCvState {}

class UploadCvInitial extends UploadCvState {}

class UploadCvPicked extends UploadCvState {
  final File file;
  UploadCvPicked(this.file);
}

class UploadCvUploading extends UploadCvState {
  final double progress;
  UploadCvUploading(this.progress);
}

class UploadCvSuccess extends UploadCvState {
  final File file;
  UploadCvSuccess(this.file);
}

class UploadCvError extends UploadCvState {
  final String message;
  UploadCvError(this.message);
}
