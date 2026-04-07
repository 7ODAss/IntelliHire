import '../models/candidate_profile_model.dart';

abstract class BaseCandidateProfileDataSource {
  Future<CandidateProfileModel> fetchProfile();
  Future<CandidateProfileModel> updateProfile(CandidateProfileModel profile);
  Future<void> changePassword(String currentPass, String newPass);
}

/// Stub with dummy profile — swap for real API when backend is ready.
class CandidateProfileRemoteDataSource
    implements BaseCandidateProfileDataSource {
  @override
  Future<CandidateProfileModel> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return const CandidateProfileModel(
      id: 'u1',
      name: 'Mahmoud Magdy',
      email: 'mahmoud.m@gmail.com',
      track: 'Frontend Engineering Track',
      avatarInitials: 'MM',
    );
  }

  @override
  Future<CandidateProfileModel> updateProfile(
    CandidateProfileModel profile,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return profile;
  }

  @override
  Future<void> changePassword(String currentPass, String newPass) async {
    await Future.delayed(const Duration(seconds: 1));
    // TODO: Call real API endpoint for password change
  }
}
