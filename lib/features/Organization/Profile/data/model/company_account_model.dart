import '../../domain/entity/company_location.dart';

class CompanyAccountModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String industry;
  final String photo;
  final String about;
  final String websiteUrl;
  final List<CompanyLocationModel> locations;

  const CompanyAccountModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.industry,
    required this.photo,
    required this.about,
    required this.websiteUrl,
    required this.locations,
  });

  factory CompanyAccountModel.fromJson(Map<String, dynamic> json) {
    return CompanyAccountModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: (json['phone'] ?? json['phoneNumber'])?.toString() ?? '',
      industry: json['industry']?.toString() ?? '',
      photo: json['photo']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      websiteUrl: (json['url'] ?? json['websiteUrl'])?.toString() ?? '',
      locations: [
        CompanyLocationModel(
          country: json['country']?.toString() ?? '',
          governorate: (json['governmentId'] ?? json['government'] ?? json['governorate'])?.toString() ?? '',
          address: (json['city'] ?? json['address'])?.toString() ?? '',
        )
      ],
    );
  }

  static List<CompanyLocationModel> _parseLocations(dynamic locationsJson) {
    if (locationsJson is List) {
      return locationsJson
          .map((e) => CompanyLocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (locationsJson is Map) {
      return [CompanyLocationModel.fromJson(locationsJson as Map<String, dynamic>)];
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'industry': industry,
      'photo': photo,
      'about': about,
      'websiteUrl': websiteUrl,
      'locations': locations.map((e) => e.toJson()).toList(),
    };
  }
}

class CompanyLocationModel extends CompanyLocation {
  const CompanyLocationModel({
    required super.country,
    required super.governorate,
    required super.address,
  });

  factory CompanyLocationModel.fromJson(Map<String, dynamic> json) {
    return CompanyLocationModel(
      country: json['country']?.toString() ?? '',
      governorate: (json['government'] ?? json['governorate'])?.toString() ?? '',
      address: (json['city'] ?? json['address'])?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'government': governorate,
      'city': address,
    };
  }
}
