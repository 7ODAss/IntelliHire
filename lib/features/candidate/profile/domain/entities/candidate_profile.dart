import 'package:equatable/equatable.dart';

class CandidateProfile extends Equatable {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String photo;
  final String currentRole;
  final double experienceYears;
  final String cvData;
  final String cvFileName;

  const CandidateProfile({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.photo,
    required this.currentRole,
    required this.experienceYears,
    required this.cvData,
    required this.cvFileName,
  });

  factory CandidateProfile.empty() => const CandidateProfile(
    fullName: '',
    email: '',
    phoneNumber: '',
    photo: '',
    currentRole: '',
    experienceYears: 0,
    cvData: '',
    cvFileName: '',
  );

  CandidateProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photo,
    String? currentRole,
    double? experienceYears,
    String? cvData,
    String? cvFileName,
  }) {
    return CandidateProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      currentRole: currentRole ?? this.currentRole,
      experienceYears: experienceYears ?? this.experienceYears,
      cvData: cvData ?? this.cvData,
      cvFileName: cvFileName ?? this.cvFileName,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    phoneNumber,
    photo,
    currentRole,
    experienceYears,
    cvData,
    cvFileName,
  ];
}
