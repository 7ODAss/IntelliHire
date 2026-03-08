import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/applicant_model.dart';

part 'applicants_state.dart';

class ApplicantsCubit extends Cubit<ApplicantsState> {
  ApplicantsCubit() : super(const ApplicantsState());

  void changeFilter(String newFilter) {
    emit(state.copyWith(selectedFilter: newFilter));
  }

  void updateApplicantStatus(String applicantId, String newStatus) {
    final updatedList = state.allApplicants.map((applicant) {
      if (applicant.id == applicantId) {
        return applicant.copyWith(status: newStatus); 
      }
      return applicant;
    }).toList();

    emit(state.copyWith(allApplicants: updatedList));
  }

  //fun مؤقتة 
void addDummyApplicants() {
  final List<ApplicantModel> dummyList = [
    ApplicantModel(
      id: '1',
      name: "Omar Ahmed",
      status: "Accepted",
      role: "Flutter Developer",
      aiScore: 95,
      strengths: [
        "Exceptional ability to write clean, maintainable, and highly optimized Flutter code following SOLID principles.",
        "Strong understanding of complex state management solutions like BLoC and Riverpod, ensuring scalable app architectures.",
        "Excellent problem-solving skills with a proven track record of reducing app load times and fixing critical memory leaks."
      ],
      weaknesses: [
        "Sometimes struggles with writing comprehensive unit and widget tests, which can lead to delayed bug detection in production.",
        "Tends to over-engineer simple solutions occasionally, requiring extra time for code reviews and simplification."
      ],
    ),
    ApplicantModel(
      id: '2',
      name: "Sarah Mohamed",
      status: "Pending",
      role: "UI/UX Designer",
      aiScore: 85,
      strengths: [
        "Highly creative with a strong eye for detail, consistently delivering pixel-perfect wireframes and interactive prototypes.",
        "Profound understanding of user-centered design and empathy for the end-user, ensuring highly accessible and intuitive interfaces.",
        "Proficient in industry-standard tools like Figma, Adobe XD, and Sketch, with excellent collaboration skills across design teams."
      ],
      weaknesses: [
        "Can be slow in delivering final design assets when working under exceptionally tight deadlines or high-pressure situations.",
        "Needs improvement in translating abstract design concepts into realistic, technically feasible requirements for the development team."
      ],
    ),
    ApplicantModel(
      id: '3',
      name: "Ahmed Ali",
      status: "Rejected",
      role: "Backend Developer",
      aiScore: 60,
      strengths: [
        "Solid understanding of server-side security protocols, data encryption, and implementing secure authentication flows.",
        "Capable of designing robust database schemas and writing highly efficient SQL/NoSQL queries for complex data structures.",
        "Good practical knowledge of deploying scalable cloud infrastructure using AWS and Docker containers."
      ],
      weaknesses: [
        "Frequently struggles with implementing complex business logic, often requiring multiple revisions and guidance from senior engineers.",
        "Communication skills are somewhat lacking, which makes cross-functional team collaboration and sprint planning challenging.",
        "Code documentation is often incomplete or missing entirely, making it difficult for other developers to maintain the codebase."
      ],
    ),
    ApplicantModel(
      id: '4',
      name: "Yassin Mahmoud",
      status: "Pending",
      role: "Mobile Developer",
      aiScore: 92,
      strengths: [
        "Deep understanding of mobile app architecture, Clean Architecture paradigms, and modular project structures.",
        "Highly proficient in dealing with native platform channels (iOS/Android bridging) to integrate third-party native SDKs seamlessly.",
        "Excellent performance optimization skills, demonstrating a strong ability to profile apps and achieve smooth 60fps rendering."
      ],
      weaknesses: [
        "Lacks advanced knowledge of modern, complex UI animations and creating custom, highly interactive transitions.",
        "Prefers working independently in silos and can sometimes be resistant to adopting new design paradigms or agile methodologies."
      ],
    ),
  ];

  emit(state.copyWith(
    allApplicants: dummyList,
    selectedFilter: "All",
  ));
}
}