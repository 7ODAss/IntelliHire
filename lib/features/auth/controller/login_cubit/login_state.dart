part of 'login_cubit.dart';

class LoginState extends Equatable {
  final int currentIndex;
  final bool changeSuffix;
  final bool rememberMeCheck;
  final LoginModel? loginModel;
  final RequestState loginState;
  final String loginMessage;


  const LoginState({
    this.currentIndex = 0,
    this.changeSuffix = true,
    this.rememberMeCheck = false,
    this.loginModel,
    this.loginState = RequestState.initial,
    this.loginMessage = '',
  });

  LoginState copyWith({
    int? currentIndex,
    bool? changeSuffix,
    bool? checkBoxTermsConditions,
    RequestState? loginState,
    String? loginMessage,
    LoginModel? loginModel,
  }) {
    return LoginState(
      currentIndex: currentIndex ?? this.currentIndex,
      changeSuffix: changeSuffix ?? this.changeSuffix,
      rememberMeCheck: checkBoxTermsConditions ?? rememberMeCheck,
      loginState: loginState ?? this.loginState,
      loginMessage: loginMessage ?? this.loginMessage,
      loginModel: loginModel ?? this.loginModel,
    );
  }

  @override
  List<Object?> get props => [
        currentIndex,
        changeSuffix,
        rememberMeCheck,
        loginState,
        loginMessage,
        loginModel,
      ];
}
