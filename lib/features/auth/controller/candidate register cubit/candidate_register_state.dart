abstract class CandidateRegisterState {}

class CandidateRegisterInitial extends CandidateRegisterState {}

class CandidateRegisterLoading extends CandidateRegisterState {}

class CandidateRegisterSuccess extends CandidateRegisterState {}

class CandidateRegisterFailure extends CandidateRegisterState {
  final String errorMsg;
  final bool isStep1Error;
  CandidateRegisterFailure(this.errorMsg, {this.isStep1Error = false});
}

class EmailConfirmationLoading extends CandidateRegisterState {}

class EmailConfirmationSuccess extends CandidateRegisterState {}

class EmailConfirmationFailure extends CandidateRegisterState {
  final String errorMsg;
  EmailConfirmationFailure(this.errorMsg);
}
