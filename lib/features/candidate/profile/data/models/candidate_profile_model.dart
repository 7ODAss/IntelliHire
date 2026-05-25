import '../../domain/entities/candidate_profile.dart';

class CandidateProfileModel extends CandidateProfile {
  const CandidateProfileModel({
    required super.fullName,
    required super.email,
    required super.photo,
  });

  factory CandidateProfileModel.fromJson(Map<String, dynamic> json) =>
      CandidateProfileModel(
        fullName: json['fullName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        photo: json['photo'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'photo': photo,
  };
}
