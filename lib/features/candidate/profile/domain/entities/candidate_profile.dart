import 'package:equatable/equatable.dart';

class CandidateProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String track;
  final String avatarInitials;

  const CandidateProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.track,
    required this.avatarInitials,
  });

  factory CandidateProfile.empty() => const CandidateProfile(
        id: '',
        name: '',
        email: '',
        track: '',
        avatarInitials: '',
      );

  @override
  List<Object?> get props => [id, name, email, track, avatarInitials];
}
