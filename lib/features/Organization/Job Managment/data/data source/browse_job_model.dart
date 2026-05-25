class BrowseJobModel {
  final String id;
  final String title;
  final String? location;
  final String? type;
  final int applicantsCount;
  final String? startedAt;
  final String? description;
  final String? requirements;
  final String? careerLevel;
  final int? experienceYears;
  final List<String>? requiredSkills;

  BrowseJobModel({
    required this.id,
    required this.title,
    this.location,
    this.type,
    required this.applicantsCount,
    this.startedAt,
    // 🔴
    this.description,
    this.requirements,
    this.careerLevel,
    this.experienceYears,
    this.requiredSkills,
  });

  factory BrowseJobModel.fromJson(Map<String, dynamic> json) {
    return BrowseJobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      location: json['location'],
      type: json['type'] ?? 'Full Time',
      applicantsCount: json['applicantsCount'] ?? 0,
      startedAt: json['startedAt'],

      // 🔴 الحل السحري هنا: بنسحب الداتا بأمان، لو null هتدخل null من غير ما تكسر الدنيا
      description: json['description'],
      requirements: json['requirements'],
      careerLevel: json['careerLevel'],

      // لو سنين الخبرة جاية string أو رقم أو null هنتعامل معاها
      experienceYears: json['experienceYears'] != null
          ? int.tryParse(json['experienceYears'].toString())
          : null,

      // هنا لو المهارات جاية null مش هيضرب إيرور، هيعمل لستة فاضية []
      requiredSkills: json['requiredSkills'] != null
          ? (json['requiredSkills'] as String)
                .split(',')
                .map((e) => e.trim())
                .toList()
          : [],
    );
  }
}
