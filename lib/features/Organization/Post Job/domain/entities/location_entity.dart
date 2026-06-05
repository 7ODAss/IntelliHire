class LocationEntity {
  final String id;
  final String country;
  final String city;
  final String government;

  LocationEntity({
    required this.id,
    required this.country,
    required this.city,
    required this.government,
  });

  String get formattedLocation {
    return "$government, $city, $country";
  }
}