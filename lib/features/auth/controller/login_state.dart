part of 'login_cubit.dart';

class LoginState extends Equatable {
  final int currentIndex;
  final bool changeSuffix;

  const LoginState({
    this.currentIndex = 0,
    this.changeSuffix = true,
  });

  LoginState copyWith({int? currentIndex, bool? changeSuffix}) {
    return LoginState(
      currentIndex: currentIndex ?? this.currentIndex,
      changeSuffix: changeSuffix ?? this.changeSuffix,
    );
  }

  @override
  List<Object?> get props => [currentIndex, changeSuffix];
}
