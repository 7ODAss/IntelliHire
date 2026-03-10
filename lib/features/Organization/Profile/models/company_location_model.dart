import 'package:equatable/equatable.dart';

class CompanyLocationModel extends Equatable {
  final String country;
  final String governorate;
  final String address;

  const CompanyLocationModel({
    required this.country,
    required this.governorate,
    required this.address,
  });

  @override
  List<Object?> get props => [country, governorate, address];
}