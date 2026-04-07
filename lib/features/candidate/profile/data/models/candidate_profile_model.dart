import '../../domain/entities/candidate_profile.dart';

class CandidateProfileModel extends CandidateProfile {
  const CandidateProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.track,
    required super.avatarInitials,
  });

  factory CandidateProfileModel.fromJson(Map<String, dynamic> json) => CandidateProfileModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        track: json['track'] as String? ?? '',
        avatarInitials: json['avatar_initials'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'track': track,
        'avatar_initials': avatarInitials,
      };
}
