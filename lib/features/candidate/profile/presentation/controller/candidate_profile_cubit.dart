import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/enums/request.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../domain/entities/candidate_profile.dart';
import '../../domain/usecases/profile_usecases.dart';

part 'candidate_profile_state.dart';

class CandidateProfileCubit extends Cubit<CandidateProfileState> {
  final FetchCandidateProfileUseCase fetchProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  CandidateProfileCubit(this.fetchProfileUseCase, this.changePasswordUseCase)
      : super(const CandidateProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: RequestState.loading));
    final result = await fetchProfileUseCase(const NoParameters());
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestState.error,
        errorMessage: failure.message,
      )),
      (profile) => emit(state.copyWith(
        status: RequestState.success,
        profile: profile,
      )),
    );
  }

  Future<void> changePassword(String currentPass, String newPass) async {
    emit(state.copyWith(changePasswordStatus: RequestState.loading));
    final result = await changePasswordUseCase(ChangePasswordParams(currentPass, newPass));
    result.fold(
      (failure) => emit(state.copyWith(
        changePasswordStatus: RequestState.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(changePasswordStatus: RequestState.success)),
    );
  }
}
