import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/candidate/home/domain/entities/home_summary.dart';
import 'package:intelli_hire/features/candidate/home/domain/usecases/get_home_summary_usecase.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeSummaryUseCase getHomeSummaryUseCase;
  HomeCubit(this.getHomeSummaryUseCase) : super(const HomeState());


  //api
    Map<int, List<int>> weekActivityData = {
    0: [5, 9, 2, 0, 4, 20, 6],
    -1: [3, 7, 5, 8, 2, 10, 4],
    -2: [1, 4, 9, 3, 6, 8, 7],
  };

   List<String> weekDays = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];

  List<int> get currentActivity =>
      weekActivityData[state.weekOffset] ?? List.filled(7, 0);

  ({String month, int year, int weekNum}) weekLabel() {
    final now = DateTime.now();
    final startOfCurrentWeek = now.subtract(Duration(days: now.weekday % 7));
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
    emit(state.copyWith(status: RequestState.loading));
    final result = await getHomeSummaryUseCase(const NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestState.error,
        errorMessage: failure.message,
      )),
      (summary) => emit(state.copyWith(
        status: RequestState.success,
        homeSummary: summary,
      )),
    );
  }

  void changeWeekOffset(int offset) {
    emit(state.copyWith(weekOffset: state.weekOffset + offset));
  }
}
