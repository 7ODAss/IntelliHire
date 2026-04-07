import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_candidate_state.dart';

class BottomNavCandidateCubit extends Cubit<BottomNavCandidateState> {
  BottomNavCandidateCubit() : super(const BottomNavInitial());
  int previousIndex = 0;

  void goBackToPrevious() {
    emit(BottomNavUpdated(previousIndex));
  }

  void changeIndex(int newIndex) {
    if (state.index != newIndex) {
      previousIndex = state.index; 
      emit(BottomNavUpdated(newIndex)); 
    }
  }
}
