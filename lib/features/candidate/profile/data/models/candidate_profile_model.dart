import '../../domain/entities/candidate_profile.dart';

class CandidateProfileModel extends CandidateProfile {
  const CandidateProfileModel({
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.photo,
    required super.currentRole,
    required super.experienceYears,
    required super.cvData,
    required super.cvFileName,
  });

  factory CandidateProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return CandidateProfileModel(
      fullName: data['fullName'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      photo: data['photo'] as String? ?? '',
      currentRole: data['currentRole'] as String? ?? '',
      experienceYears: data['experienceYears'] as double? ?? 0,
      cvData: data['cvData'] as String? ?? '',
      cvFileName: data['cvFileName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'phone': phoneNumber,
    'photo': photo,
    'currentRole': currentRole,
    'experienceYears': experienceYears,
    'cvData': cvData,
    'cvFileName': cvFileName,
  };
}
