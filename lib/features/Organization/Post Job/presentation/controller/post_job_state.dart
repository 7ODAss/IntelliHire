// Organization/Post Job/controller/post_job_state.dart
abstract class PostJobState {}

class PostJobInitial extends PostJobState {}
class PostJobUpdated extends PostJobState {}
class PostJobLoading extends PostJobState {} 
class PostJobSuccess extends PostJobState {} 
class PostJobError extends PostJobState {   
  final String message;
  PostJobError(this.message);
}

class GetLocationsLoading extends PostJobState {}
class GetLocationsSuccess extends PostJobState {}
class GetLocationsFailure extends PostJobState {
  final String errorMessage;
  GetLocationsFailure(this.errorMessage);
}