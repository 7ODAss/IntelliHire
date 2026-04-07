import '../models/assessment_model.dart';
import '../models/performance_report_model.dart';
import '../models/question_result_model.dart';

abstract class BaseAssessManageDataSource {
  Future<List<AssessmentModel>> fetchAssessmentHistory();
  Future<PerformanceReportModel> fetchPerformanceReport(String assessmentId);
}

/// Stub with dummy data — swap fetch calls for real Dio/HTTP when API is ready.
class AssessManageRemoteDataSource implements BaseAssessManageDataSource {
  // ── Dummy Data ──────────────────────────────────────────────────────────────
  static final List<AssessmentModel> _dummyAssessments = [
    const AssessmentModel(
      id: 'a1',
      title: 'Front-End Assessment',
      track: 'Frontend Engineering Track',
      aiScore: 90,
      performanceBadge: 'Excellent Performance',
      date: 'Oct 25, 2023',
    ),
    const AssessmentModel(
      id: 'a2',
      title: 'Front-End Assessment',
      track: 'Frontend Engineering Track',
      aiScore: 75,
      performanceBadge: 'Solid Effort',
      date: 'Oct 25, 2023',
    ),
    const AssessmentModel(
      id: 'a3',
      title: 'Front-End Assessment',
      track: 'Frontend Engineering Track',
      aiScore: 60,
      performanceBadge: 'Training Performance',
      date: 'Oct 20, 2023',
    ),
  ];

  static final _dummyReport = PerformanceReportModel(
    title: 'Front-End Assessment',
    track: 'Frontend Engineering Track',
    assessmentId: 'a1',
    aiScore: 88,
    totalQuestions: 4,
    accuracy: 96,
    totalTime: '15m 30s',
    avgReply: '1.2s',
    results: [
      const QuestionResultModel(
        questionText:
            'Can you tell us about yourself and your background in software development?',
        transcribedAnswer:
            'I have been working as a frontend developer for 2 years, mainly using React and Flutter.',
        idealAnswer:
            'A strong candidate should mention their core tech stack, years of experience, notable projects, and passion for the role.',
      ),
      const QuestionResultModel(
        questionText: 'What is your experience with React Hooks?',
        transcribedAnswer:
            'I use useState, useEffect and custom hooks regularly in my projects.',
        idealAnswer:
            'Hooks like useState, useEffect, useContext and custom hooks allow functional components to manage state and side effects cleanly.',
      ),
      const QuestionResultModel(
        questionText:
            'Which widget is used to create a scrollable list of items in Flutter?',
        transcribedAnswer: 'ListView',
        idealAnswer:
            'ListView or ListView.builder is the standard widget for scrollable lists in Flutter.',
      ),
      const QuestionResultModel(
        questionText: 'What does the const keyword do in Dart?',
        transcribedAnswer:
            'It creates compile-time constants that are immutable and reused.',
        idealAnswer:
            'The const keyword creates compile-time constant values, improving performance by sharing identical instances.',
      ),
    ],
  );
  // ────────────────────────────────────────────────────────────────────────────

  @override
  Future<List<AssessmentModel>> fetchAssessmentHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    return _dummyAssessments;
  }

  @override
  Future<PerformanceReportModel> fetchPerformanceReport(
    String assessmentId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return _dummyReport;
  }
}
