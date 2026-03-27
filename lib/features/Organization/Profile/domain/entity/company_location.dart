import 'package:equatable/equatable.dart';

class CompanyLocation extends Equatable {
  final String country;
  final String governorate;
  final String address;

  const CompanyLocation({
    required this.country,
    required this.governorate,
    required this.address,
  });

  @override
  List<Object?> get props => [country, governorate, address];
}