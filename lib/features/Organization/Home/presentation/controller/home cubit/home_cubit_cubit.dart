import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Home/domain/usecases/get_home_data_usecase.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_state.dart';

class HomeOrganizationCubit extends Cubit<HomeState> {
  final GetDashboardUseCase getDashboardUseCase;

  HomeOrganizationCubit(this.getDashboardUseCase) : super(HomeInitial());

  Future<void> fetchDashboard() async {
    emit(HomeLoading());
    final result = await getDashboardUseCase.execute();

    result.fold(
          (failureMessage) => emit(HomeError(failureMessage)),
          (dashboardData) => emit(HomeLoaded(dashboardData)),
    );
  }
}