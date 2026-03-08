part of 'bottom_nav_cubit.dart';

sealed class BottomNavState extends Equatable {
  final int index;
  const BottomNavState(this.index);
  @override
  List<Object> get props => [index];
}

class BottomNavInitial extends BottomNavState {
  const BottomNavInitial() : super(0);
}

class BottomNavUpdated extends BottomNavState {
  const BottomNavUpdated(super.index);
}




