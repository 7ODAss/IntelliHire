class ApplicantModel {
  final String id; 
  final String name;
  final String role;
  final int aiScore;
  final String status; 
  final List<String> strengths;
  final List<String> weaknesses;

  ApplicantModel({
    required this.id,
    required this.name,
    required this.role,
    required this.aiScore,
    this.status = "Pending",
    required this.strengths,
    required this.weaknesses,
  });

  ApplicantModel copyWith({String? status}) {
    return ApplicantModel(
      id: id,
      name: name,
      role: role,
      aiScore: aiScore,
      status: status ?? this.status,
      strengths: strengths,
      weaknesses: weaknesses,
    );
  }
}