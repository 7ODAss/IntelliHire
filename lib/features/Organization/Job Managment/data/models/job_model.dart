import '../../domain/entities/job_entity.dart';

class JobItemModel extends JobItemEntity {
  JobItemModel({
    required super.id,
    required super.title,
    required super.type,
    super.location,
    required super.postedAt,
    required super.applicantsCount,
    super.description,
    super.requirements,
    super.careerLevel,
    super.experienceYears,
    super.requiredSkills,
    super.category,
    super.subCategory,
    super.startedAt,
    super.endedAt,
    super.cvCount,
    super.codingCount,
    super.behavioralCount,
    super.technicalCount,
  });

  factory JobItemModel.fromJson(Map<String, dynamic> json) {
    print("JobItemModel.fromJson raw JSON map for job '${json['title']}': $json");

    // 🌟 1. تأمين قراءة المهارات (من requiredSkills أو skillsAndTools)
    List<String> parsedSkills = [];
    final skillsData = json['requiredSkills'] ?? json['skillsAndTools'];
    if (skillsData != null) {
      if (skillsData is String) {
        parsedSkills = skillsData.toString().split(',').map((e) => e.trim()).toList();
      } else if (skillsData is List) {
        parsedSkills = List<String>.from(skillsData);
      }
    }

    String expStr = (json['experienceYears'] ?? '').toString();
    String expNumOnly = expStr.replaceAll(RegExp(r'[^0-9]'), ''); 
    int? expParsed = int.tryParse(expNumOnly);

    int parseApplicantsCount(Map<String, dynamic> json) {
      if (json['applicantsCount'] != null) {
        return int.tryParse(json['applicantsCount'].toString()) ?? 0;
      }
      if (json['applicants'] != null) {
        if (json['applicants'] is List) {
          return (json['applicants'] as List).length;
        }
        return int.tryParse(json['applicants'].toString()) ?? 0;
      }
      if (json['users'] != null && json['users'] is List) {
        return (json['users'] as List).length;
      }
      if (json['candidatesCount'] != null) {
        return int.tryParse(json['candidatesCount'].toString()) ?? 0;
      }
      if (json['totalApplicants'] != null) {
        return int.tryParse(json['totalApplicants'].toString()) ?? 0;
      }
      if (json['candidates'] != null) {
        if (json['candidates'] is List) {
          return (json['candidates'] as List).length;
        }
        return int.tryParse(json['candidates'].toString()) ?? 0;
      }
      return 0;
    }

    return JobItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      // دعمنا locations و location
      location: json['location']?.toString() ?? json['locations']?.toString(),
      postedAt: json['postedAt']?.toString() ?? '',
      applicantsCount: parseApplicantsCount(json),
      description: json['description']?.toString(),
      
      requirements: json['requirements']?.toString() ?? json['jobrequirements']?.toString(),
      careerLevel: json['careerLevel']?.toString(),
      
      experienceYears: expParsed,
      
      requiredSkills: parsedSkills, 
          
      category: json['category']?.toString(),
      
      subCategory: json['subCategory']?.toString() ?? json['subCtegory']?.toString(),
      
      startedAt: json['startedAt']?.toString() ?? json['startDateTime']?.toString(),
      endedAt: json['endedAt']?.toString() ?? json['endDateTime']?.toString(),
      
      cvCount: int.tryParse(json['cvCount']?.toString() ?? json['questionCount']?.toString() ?? json['questionsCount']?.toString() ?? '0'),
      codingCount: int.tryParse(json['codingCount']?.toString() ?? '0'),
      behavioralCount: int.tryParse(json['behavioralCount']?.toString() ?? '0'),
      technicalCount: int.tryParse(json['technicalCount']?.toString() ?? '0'),
    );
  }
}

class JobManagementModel extends JobManagementEntity {
  JobManagementModel({
    required super.activeJobs,
    required super.totalApplicants,
    required super.jobs,
  });

  factory JobManagementModel.fromJson(Map<String, dynamic> json) {
    return JobManagementModel(
      activeJobs: json['activeJobs'] ?? 0,
      totalApplicants: json['totalApplicants'] ?? 0,
      jobs: json['jobs'] != null
          ? List<JobItemModel>.from(
              (json['jobs'] as List).map((x) => JobItemModel.fromJson(x)),
            )
          : [],
    );
  }
}
