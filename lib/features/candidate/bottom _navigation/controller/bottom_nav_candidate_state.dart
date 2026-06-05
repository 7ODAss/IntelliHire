part of 'bottom_nav_candidate_cubit.dart';

sealed class BottomNavCandidateState extends Equatable {
  final int index;
  const BottomNavCandidateState(this.index);
  @override
  List<Object> get props => [index];
}

class BottomNavInitial extends BottomNavCandidateState {
  const BottomNavInitial() : super(0);
}

class BottomNavUpdated extends BottomNavCandidateState {
  const BottomNavUpdated(super.index);
}




