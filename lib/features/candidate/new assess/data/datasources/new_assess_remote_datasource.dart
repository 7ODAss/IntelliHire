import 'package:intelli_hire/features/candidate/assess%20manage/data/models/performance_report_model.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/data/models/question_result_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/data/models/question_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question_type.dart';

abstract class BaseNewAssessDataSource {
  Future<List<QuestionModel>> fetchAssessmentQuestions(String assessmentId);
  Future<PerformanceReportModel> submitInterview(
    String assessmentId,
    List<String> recordingPaths,
    Map<String, String> mcqAnswers,
  );
}

/// Stub with dummy questions — swap for real API when backend is ready.
class NewAssessRemoteDataSource implements BaseNewAssessDataSource {
  static final List<QuestionModel> _dummyQuestions = [
    const QuestionModel(
      id: 'q1',
      text: 'Can you tell us about yourself and your background in software development?',
      number: 1,
      total: 4,
      type: QuestionType.audio,
    ),
    const QuestionModel(
      id: 'q2',
      text: 'What is your experience with React Hooks and state management?',
      number: 2,
      total: 4,
      type: QuestionType.audio,
    ),
    const QuestionModel(
      id: 'q3',
      text: 'Which widget is used to create a scrollable list of items in Flutter?',
      number: 3,
      total: 4,
      type: QuestionType.mcq,
      options: ['Stack', 'ListView', 'Column', 'Container'],
      correctOption: 'ListView',
    ),
    const QuestionModel(
      id: 'q4',
      text: 'What does the const keyword do in Dart?',
      number: 4,
      total: 4,
      type: QuestionType.mcq,
      options: [
        'Declares a variable that can change',
        'Creates a compile-time constant',
        'Marks a class as abstract',
        'Defines a final variable',
      ],
      correctOption: 'Creates a compile-time constant',
    ),
  ];

  @override
  Future<List<QuestionModel>> fetchAssessmentQuestions(
    String assessmentId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return _dummyQuestions;
  }

  @override
  Future<PerformanceReportModel> submitInterview(
    String assessmentId,
    List<String> recordingPaths,
    Map<String, String> mcqAnswers,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    return PerformanceReportModel(
      title: 'Front-End Assessment',
      track: 'Frontend Engineering Track',
      assessmentId: assessmentId,
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
          questionText:
              'What is your experience with React Hooks and state management?',
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
  }
}
