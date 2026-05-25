import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/home_summary.dart';
import 'package:intelli_hire/features/candidate/home/domain/usecases/get_home_summary_usecase.dart';
import 'package:intelli_hire/features/candidate/home/domain/usecases/get_next_week_usecase.dart';

import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../domain/entities/weekly_activity_summary.dart';
import '../../domain/usecases/get_prev_week_usecase.dart';
import '../../domain/usecases/reset_week_usecase.dart';

part 'home_state.dart';

class HomeCubitCandidate extends Cubit<HomeState> {
  final GetHomeSummaryUseCase getHomeSummaryUseCase;
  final GetNextWeekUseCase getNextWeekUseCase;
  final GetPrevWeekUseCase getPrevWeekUseCase;
  final ResetWeekUseCase resetWeekUseCase;

  HomeCubitCandidate(
    this.getHomeSummaryUseCase,
    this.getNextWeekUseCase,
    this.getPrevWeekUseCase,
    this.resetWeekUseCase,
  ) : super(const HomeState());


  List<String> weekDays = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];

  ({String month, int year, int weekNum}) weekLabel() {
    final now = DateTime.now();
    final startOfCurrentWeek = now.subtract(Duration(days: (now.weekday) % 7));
    final startOfDisplayedWeek = startOfCurrentWeek.add(
      Duration(days: state.weekOffset * 7),
    );
    final month = monthName(startOfDisplayedWeek.month);
    final year = startOfDisplayedWeek.year;
    final weekNum = ((startOfDisplayedWeek.day - 1) ~/ 7) + 1;
    return (month: month, year: year, weekNum: weekNum);
  }

  String monthName(int month) {
    const names = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month];
  }

  int get todayIndex {
    if (state.weekOffset != 0) return -1;
    final wd = DateTime.now().weekday;
    const map = {7: 0, 6: 1, 1: 2, 2: 3, 3: 4, 4: 5, 5: 6};
    return map[wd] ?? -1;
  }

  Future<void> loadHomeData() async {
    emit(state.copyWith(homeSummaryStatus: RequestState.loading));
    final result = await getHomeSummaryUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          homeSummaryStatus: RequestState.error,
          homeSummaryMessage: failure.message,
        ),
      ),
      (summary) => emit(
        state.copyWith(homeSummaryStatus: RequestState.success, homeSummary: summary),
      ),
    );
    print('home model: ${state.homeSummary}');
  }

  // void changeWeekOffset(int offset) {
  //   emit(state.copyWith(weekOffset: state.weekOffset + offset));
  // }

  Future<void> getNextWeek() async {
    emit(state.copyWith(weekActivityState: RequestState.loading));
    final result = await getNextWeekUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
          (failure) => emit(
        state.copyWith(
          weekActivityState: RequestState.error,
          weekActivityMessage: failure.message,
        ),
      ),
          (summary) => emit(
        state.copyWith(weekActivityState: RequestState.success, weekActivity: summary, weekOffset: state.weekOffset + 1),
      ),
    );
    print('home model: ${state.homeSummary}');
  }

  Future<void> getPrevWeek() async {
    emit(state.copyWith(weekActivityState: RequestState.loading));
    final result = await getPrevWeekUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
          (failure) => emit(
        state.copyWith(
          weekActivityState: RequestState.error,
          weekActivityMessage: failure.message,
        ),
      ),
          (summary) => emit(
        state.copyWith(weekActivityState: RequestState.success, weekActivity: summary, weekOffset: state.weekOffset - 1),
      ),
    );
    print('home model: ${state.homeSummary}');
  }

  void resetWeek() async{
    emit(state.copyWith(weekActivityState: RequestState.loading));
    final result = await resetWeekUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
          (failure) => emit(
        state.copyWith(
          weekActivityState: RequestState.error,
          weekActivityMessage: failure.message,
        ),
      ),
          (summary) => emit(
        state.copyWith(weekActivityState: RequestState.success, weekActivity: summary, weekOffset: 0),
      ),
    );
    print('home model: ${state.homeSummary}');
  }
}
