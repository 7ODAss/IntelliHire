import 'package:flutter/material.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/current_job_list_view.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/current_jobs_header.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/top_canddidate_card.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/widget/top_section.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/applicant_model.dart';

class OrganizationHomeView extends StatelessWidget {
  const OrganizationHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ApplicantModel> mockApplicants = [
      ApplicantModel(
        id: '1',
        name: 'Omar Osama',
        role: 'Senior React Developer',
        aiScore: 92,
        strengths: ['Demonstrated deep understanding of React Lifecycle.'],
        weaknesses: ['Lacked practical experience with Unit Testing (Jest).'],
      ),
      ApplicantModel(
        id: '2',
        name: 'Ahmed Ali',
        role: 'Flutter Developer',
        aiScore: 88,
        strengths: [
          'Great state management skills with Bloc.',
          'Clean Code architecture.',
        ],
        weaknesses: [
          'Needs improvement in writing native code (Kotlin/Swift).',
        ],
      ),
      ApplicantModel(
        id: '3',
        name: 'Sara Mohamed',
        role: 'UI/UX Designer',
        aiScore: 95,
        strengths: [
          'Excellent prototyping on Figma.',
          'User-centered design approach.',
        ],
        weaknesses: ['Animation basics need some work.'],
      ),
      ApplicantModel(
        id: '4',
        name: 'Mahmoud Hassan',
        role: 'Backend Node.js',
        aiScore: 80,
        strengths: ['Strong database modeling.', 'Good API design.'],
        weaknesses: ['Microservices experience is limited.'],
      ),
      ApplicantModel(
        id: '5',
        name: 'Nour Tariq',
        role: 'Product Manager',
        aiScore: 90,
        strengths: [
          'Agile methodology expert.',
          'Excellent communication skills.',
        ],
        weaknesses: ['Technical background could be stronger.'],
      ),
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopSection(),
            const SizedBox(height: 24),
            TopCanddidateCard(applicants: mockApplicants),
            CurrentJobsHeader(),
            const SizedBox(height: 20),
            CurrentJobListView(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
