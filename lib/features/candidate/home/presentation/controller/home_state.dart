part of 'home_cubit.dart';

class HomeState extends Equatable {
  final RequestState homeSummaryStatus;
  final HomeSummary? homeSummary;
  final String homeSummaryMessage;
  final int weekOffset;
  final WeeklyActivitySummary? weekActivity;
  final RequestState? weekActivityState;
  final String? weekActivityMessage;

  const HomeState({
    this.homeSummaryStatus = RequestState.initial,
    this.homeSummary,
    this.homeSummaryMessage = '',
    this.weekOffset = 0,
    this.weekActivity,
    this.weekActivityState,
    this.weekActivityMessage,
  });

  HomeState copyWith({
    RequestState? homeSummaryStatus,
    HomeSummary? homeSummary,
    String? homeSummaryMessage,
    int? weekOffset,
    WeeklyActivitySummary? weekActivity,
    RequestState? weekActivityState,
    String? weekActivityMessage,
  }) => HomeState(
    homeSummaryStatus: homeSummaryStatus ?? this.homeSummaryStatus,
    homeSummary: homeSummary ?? this.homeSummary,
    homeSummaryMessage: homeSummaryMessage ?? this.homeSummaryMessage,
    weekOffset: weekOffset ?? this.weekOffset,
    weekActivity: weekActivity ?? this.weekActivity,
    weekActivityState: weekActivityState ?? this.weekActivityState,
    weekActivityMessage: weekActivityMessage ?? this.weekActivityMessage,
  );

  @override
  List<Object?> get props => [
    homeSummaryStatus,
    homeSummary,
    homeSummaryMessage,
    weekOffset,
    weekActivity,
    weekActivityState,
    weekActivityMessage,
  ];
}
