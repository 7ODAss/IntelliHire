import 'package:equatable/equatable.dart';

class WorkExperience extends Equatable {
  final String title, company, dateRange, description;
  const WorkExperience({
    required this.title,
    required this.company,
    required this.dateRange,
    required this.description,
  });

  @override
  List<Object?> get props => [title, company, dateRange, description];
}
