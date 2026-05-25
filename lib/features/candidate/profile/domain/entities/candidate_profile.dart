import 'package:equatable/equatable.dart';

class CandidateProfile extends Equatable {
  final String fullName;
  final String email;
  final String photo;

  const CandidateProfile({
    required this.fullName,
    required this.email,
    required this.photo,
  });

  factory CandidateProfile.empty() =>
      const CandidateProfile(fullName: '', email: '', photo: '');

  @override
  List<Object?> get props => [fullName, email, photo];
}
