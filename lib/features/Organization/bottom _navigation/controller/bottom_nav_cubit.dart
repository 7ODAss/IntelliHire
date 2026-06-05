import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavInitial());
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
