import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String title, description;
  final List<String> technologies;
  const Project({
    required this.title,
    required this.description,
    required this.technologies,
  });

  @override
  List<Object?> get props => [title, description, technologies];
}
