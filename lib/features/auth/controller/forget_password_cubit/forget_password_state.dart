part of 'forget_password_cubit.dart';

class ForgetPasswordState extends Equatable {
  final RequestState checkEmailState;
  final String checkEmailMessage;
  final int pageIndex;
  final RequestState otpState;
  final String otpMessage;
  final bool changePasswordSuffix;
  final bool changeConfirmPasswordSuffix;
  final RequestState resetPasswordState;
  final String resetPasswordMessage;


  const ForgetPasswordState({
    this.checkEmailState = RequestState.initial,
    this.checkEmailMessage = '',
    this.pageIndex = 0,
    this.otpState = RequestState.initial,
    this.otpMessage = '',
    this.changePasswordSuffix = true,
    this.changeConfirmPasswordSuffix = true,
    this.resetPasswordState = RequestState.initial,
    this.resetPasswordMessage = '',
  });

  ForgetPasswordState copyWith({
    RequestState? checkEmailState,
    String? checkEmailMessage,
    int? pageIndex,
    RequestState? otpState,
    String? otpMessage,
    bool? changePasswordSuffix,
    bool? changeConfirmPasswordSuffix,
    RequestState? resetPasswordState,
    String? resetPasswordMessage,
  }) {
    return ForgetPasswordState(
        checkEmailState: checkEmailState ?? this.checkEmailState,
        checkEmailMessage: checkEmailMessage ?? this.checkEmailMessage,
        pageIndex: pageIndex ?? this.pageIndex,
        otpState: otpState ?? this.otpState,
        otpMessage: otpMessage ?? this.otpMessage,
        changePasswordSuffix: changePasswordSuffix ?? this.changePasswordSuffix,
        changeConfirmPasswordSuffix: changeConfirmPasswordSuffix ?? this.changeConfirmPasswordSuffix,
        resetPasswordState: resetPasswordState ?? this.resetPasswordState,
        resetPasswordMessage: resetPasswordMessage ?? this.resetPasswordMessage,
    );
  }

  @override
  List<Object?> get props =>
      [
        checkEmailState,
        checkEmailMessage,
        pageIndex,
        otpState,
        otpMessage,
        changePasswordSuffix,
        changeConfirmPasswordSuffix,
        resetPasswordState,
        resetPasswordMessage,
      ];
}
