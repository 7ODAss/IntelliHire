import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required super.id,
    required super.country,
    required super.city,
    required super.government,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      government: json['government'] ?? '',
    );
  }
}