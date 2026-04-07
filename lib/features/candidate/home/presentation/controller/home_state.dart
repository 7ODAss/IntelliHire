part of 'home_cubit.dart';

class HomeState extends Equatable {
  final RequestState status;
  final HomeSummary? homeSummary;
  final String errorMessage;
  final int weekOffset;

  const HomeState({
    this.status = RequestState.initial,
    this.homeSummary,
    this.errorMessage = '',
    this.weekOffset = 0,
  });

  HomeState copyWith({
    RequestState? status,
    HomeSummary? homeSummary,
    String? errorMessage,
    int? weekOffset,
  }) =>
      HomeState(
        status: status ?? this.status,
        homeSummary: homeSummary ?? this.homeSummary,
        errorMessage: errorMessage ?? this.errorMessage,
        weekOffset: weekOffset ?? this.weekOffset,
      );

  @override
  List<Object?> get props => [status, homeSummary, errorMessage, weekOffset];
}
