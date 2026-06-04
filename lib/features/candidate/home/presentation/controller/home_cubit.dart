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

  // Guard: prevents two concurrent loadHomeData() calls.
  bool _isLoadingHome = false;

  // Deferred-refresh flag.
  // Set to true by newassess after assessment submission so that HomeCubit
  // knows it must refresh — WITHOUT triggering the HTTP fetch (and the heavy
  // HomeScreen rebuild) while HomeScreen is buried under the newassess route.
  // HomeScreen checks and clears this flag in didChangeDependencies, which
  // only fires when the screen is actually visible/active again.
  bool needsRefresh = false;

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

  void updateHomeHeaderName(String newName) {
    if (isClosed) return;
    if (state.homeSummary != null) {
      // 🌟 بنعمل copyWith للموديل الحالي وبنعدل الـ firstName بس بنظافة
      final updatedPerformance = state.homeSummary!.trainingPerformance
          .copyWith(firstName: newName);

      final updatedSummary = state.homeSummary!.copyWith(
        trainingPerformance: updatedPerformance,
      );

      emit(
        state.copyWith(
          homeSummary: updatedSummary,
          homeSummaryStatus:
              RequestState.success, // عشان يجبر الـ buildWhen يشتغل
        ),
      );
    }
  }

  /// Clears any stale state left over from a previous session.
  /// Must be called before [loadHomeData] when re-entering HomeScreen
  /// so the singleton cubit never carries a closed/error/loading status
  /// from one assessment run into the next.
  /// Uses a fresh HomeState() constructor (not copyWith) because copyWith
  /// cannot reset nullable fields back to null via the ?? fallback pattern.
  void reset() {
    _isLoadingHome = false; // allow the next loadHomeData() call through
    needsRefresh = false;
    emit(const HomeState()); // all fields back to their default initial values
  }

  /// Called by newassess after a successful submission.
  /// Marks the cubit as needing a refresh WITHOUT triggering loadHomeData().
  /// The actual fetch is deferred until HomeScreen becomes visible again.
  void markNeedsRefresh() {
    needsRefresh = true;
  }

  Future<void> loadHomeData() async {
    // Prevent duplicate in-flight requests. If assessment_session_cubit calls
    // loadHomeData() fire-and-forget while HomeScreen.initState already has one
    // running, we skip the duplicate. The first one will emit the fresh result.
    if (_isLoadingHome) {
      print('⚠️ loadHomeData() already in flight — skipping duplicate call.');
      return;
    }
    _isLoadingHome = true;
    if (isClosed) {
      _isLoadingHome = false;
      return;
    }
    emit(state.copyWith(homeSummaryStatus: RequestState.loading));
    final result = await getHomeSummaryUseCase(const NoParameters());
    _isLoadingHome = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            homeSummaryStatus: RequestState.error,
            homeSummaryMessage: failure.message,
          ),
        );
      },
      (summary) {
        if (isClosed) return;
        emit(
          state.copyWith(
            homeSummaryStatus: RequestState.success,
            homeSummary: summary,
          ),
        );
      },
    );
    print('home model: ${state.homeSummary}');
  }

  Future<void> getNextWeek() async {
    if (isClosed) return;
    emit(state.copyWith(weekActivityState: RequestState.loading));
    final result = await getNextWeekUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            weekActivityState: RequestState.error,
            weekActivityMessage: failure.message,
          ),
        );
      },
      (summary) {
        if (isClosed) return;
        emit(
          state.copyWith(
            weekActivityState: RequestState.success,
            weekActivity: summary,
            weekOffset: state.weekOffset + 1,
          ),
        );
      },
    );
    print('home model: ${state.homeSummary}');
  }

  Future<void> getPrevWeek() async {
    if (isClosed) return;
    emit(state.copyWith(weekActivityState: RequestState.loading));
    final result = await getPrevWeekUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            weekActivityState: RequestState.error,
            weekActivityMessage: failure.message,
          ),
        );
      },
      (summary) {
        if (isClosed) return;
        emit(
          state.copyWith(
            weekActivityState: RequestState.success,
            weekActivity: summary,
            weekOffset: state.weekOffset - 1,
          ),
        );
      },
    );
    print('home model: ${state.homeSummary}');
  }

  void resetWeek() async {
    if (isClosed) return;
    emit(state.copyWith(weekActivityState: RequestState.loading));
    final result = await resetWeekUseCase(const NoParameters());
    if (isClosed) return;

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            weekActivityState: RequestState.error,
            weekActivityMessage: failure.message,
          ),
        );
      },
      (summary) {
        if (isClosed) return;
        emit(
          state.copyWith(
            weekActivityState: RequestState.success,
            weekActivity: summary,
            weekOffset: 0,
          ),
        );
      },
    );
    print('home model: ${state.homeSummary}');
  }
}
