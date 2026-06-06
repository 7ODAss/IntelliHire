import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intelli_hire/core/utils/apis/api_constant.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/data/models/performance_report_model.dart';
import 'package:intelli_hire/features/candidate/assess%20manage/data/models/question_result_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/data/models/cv_data_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/data/models/question_model.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/cv_data.dart';
import 'package:intelli_hire/features/candidate/new%20assess/domain/entities/question_type.dart';

import '../../../assess manage/domain/entities/question_result.dart';
import '../../domain/entities/question.dart';

abstract class BaseNewAssessDataSource {
  Future<List<QuestionModel>> fetchAssessmentQuestions(CvData cv);

  Future<PerformanceReportModel> submitInterview(
    Map<String, String> voiceTextAnswers,
    Map<String, String> mcqAnswers,
    List<Question> originalQuestions,
    CvData cv,
    String avgReply,
    String totalTime,
  );

  Future<String> sendAssessment(
    String trackName,
    String assessmentName,
    double overallAiScore,
    double accuracy,
    String avgReply,
    int totalQuestions,
    String duration,
    List<QuestionResult> questions,
  );

  Future<(String, String)> getCandidateId();
  Future<CvData> getCandidateCv(String candidateId);
}

class NewAssessRemoteDataSource implements BaseNewAssessDataSource {
  // 🌟 دالة جديدة لتحويل الصوت إلى نص باستخدام Groq Whisper
  Future<String> _transcribeAudio(
    String filePath,
    String apiKey,
    Dio dio,
  ) async {
    try {
      print("🎙️ جاري تفريغ الملف الصوتي: $filePath...");

      // بنجهز الملف عشان يترفع (Multipart)
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath),
        "model": "whisper-large-v3", // موديل تحويل الصوت لنص في Groq
        "response_format": "json",
        "language": "en",
      });

      final response = await dio.post(
        'https://api.groq.com/openai/v1/audio/transcriptions',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            // الـ Dio بيحط الـ multipart/form-data لوحده لما تستخدم FormData
          },
        ),
      );

      if (response.statusCode == 200) {
        final text = response.data['text'] ?? "No Answer Here";
        print("✅ تم التفريغ: $text");
        return text;
      } else {
        print("🚨 فشل التفريغ: ${response.statusCode}");
        return "No Answer Here";
      }
    } catch (e) {
      print("🚨 خطأ أثناء تفريغ الصوت: $e");
      return "No Answer Here"; // لو حصل إيرور نعتبره مجاوبش عشان التقييم ميكراشش
    }
  }

  @override
  Future<List<QuestionModel>> fetchAssessmentQuestions(CvData cv) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    if (apiKey == null) {
      throw 'GROQ_API_KEY not found in .env file';
    }
    final aiDio = Dio();
    final cvModel = cv as CvDataModel; // Downcast to access toJson
    final String cvJson = jsonEncode(cvModel.toJson());

    final String targetJobTitle = cvModel.jobTitle.isNotEmpty
        ? cvModel.jobTitle
        : "Software Engineer";

    final String sessionSeed = DateTime.now().millisecondsSinceEpoch.toString();

    final String prompt =
        """
      You are an expert technical interviewer evaluating a candidate for a "$targetJobTitle" position.
      
      SESSION ID SEED: $sessionSeed

      CANDIDATE CV DATA:
      $cvJson

      TASK:
      CRITICAL: Generate EXACTLY 10 professional, unique assessment questions.

      STRICT PERSONALIZATION & VARIETY RULES:
      1. Contextualize: Use the candidate's actual projects as the basis.
      2. HIGH VARIETY RULE: Use the SESSION ID SEED to dynamically randomize your technical focus areas. Do NOT ask the same standard or predictable questions for "$targetJobTitle". Randomly choose different deep topics (e.g., focus on performance optimization in one session, advanced state side-effects in another, security/local caching, or complex asynchronous edge cases). Every exam session must be entirely unique and unpredictable.
      3. TRACK DEDUCTION: If the job title "$targetJobTitle" is generic, unclear, or informal, deduce their exact technical track (e.g., Frontend, Backend, Mobile, DevOps) strictly from their listed skills and projects, and generate specialized questions for that track.
      4. UNIQUENESS GUARANTEE: Do NOT ask generic "What is" questions.

      RESPONSE FORMAT:
      Output ONLY a valid JSON OBJECT containing a single key "questions" which holds the array. NO markdown.
      {
        "questions": [
          {"type": "voice", "text": "...", "expected_key_points": ["...", "..."]},
          {"type": "mcq", "text": "...", "options": ["...", "..."], "correct_answer_index": 0}
        ]
      }
    """;

    try {
      print("🤖 جاري طلب الأسئلة من الذكاء الاصطناعي...");
      final response = await aiDio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "model": "qwen/qwen3-32b",
          "messages": [
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.5,
          "max_tokens": 2500,
          "response_format": {"type": "json_object"},
        },
      );

      if (response.statusCode == 200) {
        print('response.data: ${response.data}');
        final String aiContent =
            response.data['choices'][0]['message']['content'];

        // 🌟 3. بنستخرج الـ Object بناءً على أقواس { } اللي صعب تتكرر بالصدفة
        String cleanJson = aiContent;
        int startIndex = aiContent.indexOf('{');
        int endIndex = aiContent.lastIndexOf('}');

        if (startIndex != -1 && endIndex != -1) {
          cleanJson = aiContent.substring(startIndex, endIndex + 1);
        } else {
          throw 'الذكاء الاصطناعي لم يرجع البيانات بصيغة JSON';
        }

        // 🌟 4. بنفك الـ Object وندخل على مفتاح "questions"
        final Map<String, dynamic> jsonResponse = jsonDecode(cleanJson);
        final List<dynamic> jsonList = jsonResponse['questions'];

        List<QuestionModel> questions = [];
        for (int i = 0; i < jsonList.length; i++) {
          final jsonItem = jsonList[i] as Map<String, dynamic>;
          jsonItem['number'] = i + 1;
          jsonItem['total'] = jsonList.length;
          jsonItem['id'] = "q_$i";

          questions.add(QuestionModel.fromJson(jsonItem));
        }

        print("✅ تم جلب ${questions.length} أسئلة بنجاح!");
        return questions;
      } else {
        throw 'Failed to load questions from AI';
      }
    } catch (e) {
      if (e is DioException) {
        print('🚨 تفاصيل رفض Groq (400): ${e.response?.data}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      throw 'حدث خطأ أثناء التواصل مع الذكاء الاصطناعي';
    }
  }

  @override
  Future<PerformanceReportModel> submitInterview(
    Map<String, String> voiceTextAnswers,
    Map<String, String> mcqAnswers,
    List<Question> originalQuestions,
    CvData cv,
    String avgReply,
    String totalTime,
  ) async {
    final apiKey = dotenv.env['GROQ_API_KEY'];
    final aiDio = Dio();
    final cvModel = cv as CvDataModel;
    final String targetJobTitle = cvModel.jobTitle.isNotEmpty
        ? cvModel.jobTitle
        : "Software Engineer";

    try {
      print("🧠 جاري إرسال الإجابات النصية للتقييم...");

      List<Map<String, dynamic>> assessmentData = [];
      final List<QuestionModel> originalQuestionsModel = originalQuestions
          .map((q) => q as QuestionModel)
          .toList();

      for (var q in originalQuestionsModel) {
        String userAnswer = '';

        if (q.type == QuestionType.mcq) {
          userAnswer = mcqAnswers[q.id] ?? "No Answer";
        } else {
          // 🌟 هنا الشغل الجديد بتاع الصوت
          String filePath = voiceTextAnswers[q.id] ?? "";

          if (filePath.contains('.m4a') || filePath.contains('/data/user/')) {
            // لو ده مسار ملف، نبعته يتحول لنص الأول
            userAnswer = await _transcribeAudio(filePath, apiKey!, aiDio);
          } else {
            userAnswer = filePath.isNotEmpty ? filePath : "No Answer";
          }
        }

        // مسحنا الشرط القديم اللي كان بيخلي أي ملف صوت "No Answer Here"

        String idealAnswer = q.type == QuestionType.mcq
            ? "The correct answer is: '${q.correctOption}'. Please explain WHY this is the correct choice."
            : "Evaluate this based on standard Software Engineering best practices and provide the ideal answer.";

        assessmentData.add({
          "text": q.text,
          "question_type": q.type == QuestionType.mcq ? "mcq" : "voice",
          "correct_ideal_answer": idealAnswer,
          "candidate_answer": userAnswer,
        });
      }

      final String prompt =
          """
        You are an expert technical interviewer evaluating a candidate for a "$targetJobTitle" position.
        Evaluate the following candidate answers.
        
        STRICT LANGUAGE RULE:
        You MUST generate the ENTIRE JSON response strictly in ENGLISH. Do not use Arabic or any other language for any field.
        
        RULES FOR EVALUATION & FEEDBACK:
        1. For MCQ questions: Check if the answer is correct. In 'idealAnswer', explain WHY it is correct or incorrect based on the provided 'correct_ideal_answer'.
        2. For Voice questions: DO NOT just provide a script. You must act as a real human interviewer. 
           - If the candidate provided an answer: First, analyze their answer. Point out what they got right and identify their specific weak points or missing information. Then, provide the optimal answer.
           - If the candidate's answer is completely wrong: Gently correct them and provide the optimal answer.
        3. CRITICAL: You MUST output the EXACT 'candidate_answer' provided in the Assessment Data into the 'userAnswer' field without ANY modification, summarization, or translation.
        4. MISSING ANSWERS: If the 'candidate_answer' is empty, "No Answer Here", or blank, you MUST output "No Answer Here" in the 'userAnswer' field, score it as 0, and provide the complete correct answer in the 'idealAnswer' field.
        
        Calculate an overall 'overallAiScore' (0-100) and an 'accuracy' percentage (0-100).
        
        Assessment Data:
        ${jsonEncode(assessmentData)}
        
        Output ONLY a valid JSON object matching this structure EXACTLY, with NO markdown formatting:
        {
         "track": "$targetJobTitle",
          "title": "Interview Performance Report",
          "overallAiScore": 85.0,
          "accuracy": 92.5,
          "avgReply": "$avgReply",
          "totalQuestions": ${originalQuestionsModel.length},
          "duration": ${double.tryParse(totalTime)?.toInt() ?? 0},
          "questions": [
            {
              "questionText": "Question text here",
              "userAnswer": "Exact candidate answer from data or 'No Answer Here'",
              "idealAnswer": "Your constructive feedback on their answer FIRST, followed by the ideal answer. (IN ENGLISH ONLY)"
            }
          ]
        }
      """;

      final evaluationRes = await aiDio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "model": "qwen/qwen3-32b", // أو الموديل اللي استخدمته وظبط معاك
          "messages": [
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.1,
          "max_tokens": 4000,
          "response_format": {"type": "json_object"},
        },
      );

      if (evaluationRes.statusCode == 200) {
        print('evaluationRes.data: ${evaluationRes.data}');
        final String aiContent =
            evaluationRes.data['choices'][0]['message']['content'];

        // الطريقة المنيعة لاستخراج الـ JSON
        String cleanJson = aiContent;
        int startIndex = aiContent.indexOf('{');
        int endIndex = aiContent.lastIndexOf('}');

        if (startIndex != -1 && endIndex != -1) {
          cleanJson = aiContent.substring(startIndex, endIndex + 1);
        } else {
          throw 'فشل في استخراج التقرير من الذكاء الاصطناعي';
        }

        final Map<String, dynamic> reportJson = jsonDecode(cleanJson);

        print("✅ تم التقييم بنجاح!");

        return PerformanceReportModel(
          title: targetJobTitle,
          overallAiScore: (reportJson['overallAiScore'] as num).toDouble(),
          questionsCount: originalQuestionsModel.length,
          accuracy: (reportJson['accuracy'] as num).toDouble(),
          totalTime: totalTime,
          avgReply: avgReply,
          questions: (reportJson['questions'] as List)
              .map(
                (r) => QuestionResultModel(
                  questionText: r['questionText'],
                  userAnswer: r['userAnswer'],
                  idealAnswer: r['idealAnswer'],
                ),
              )
              .toList(),
        );
      } else {
        throw 'Failed to evaluate answers';
      }
    } catch (e) {
      if (e is DioException) {
        print('🚨 تفاصيل رفض Groq في التقييم (400): ${e.response?.data}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      throw 'حدث خطأ أثناء تقييم المقابلة';
    }
  }

  @override
  Future<String> sendAssessment(
    String trackName,
    String assessmentName,
    double overallAiScore,
    double accuracy,
    String avgReply,
    int totalQuestions,
    String duration,
    List<QuestionResult> questions,
  ) async {
    // 🌟 1. اختبار الطباعة: عشان نتأكد إن الـ UI باصى قيم حقيقية مش فاضية
    print("--------------------------------------------------");
    print("📤 [CHECK FLUTTER DATA] جاري التحقق من البيانات قبل الإرسال:");
    print("Track Name: '$trackName'");
    print("Assessment Name: '$assessmentName'");
    print("Total Questions: $totalQuestions");
    print("--------------------------------------------------");
    final Map<String, dynamic> requestBody = {
      "track": trackName,
      "title": assessmentName,
      "overallAiScore": overallAiScore,
      "accuracy": accuracy,
      "avgReply": avgReply.toString(),
      "totalQuestions": totalQuestions,
      "duration": double.tryParse(duration)?.toInt() ?? 0,
      "questions": questions
          .map(
            (q) => {
              "questionText": q.questionText,
              "idealAnswer": q.idealAnswer,
              "userAnswer": q.userAnswer,
            },
          )
          .toList(),
    };

    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateAssessmentSubmit,
        data: requestBody,
      );
      print("Response: $response");
      return response.data.toString();
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<(String, String)> getCandidateId() async {
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.getCandidateId,
      );
      if (response.statusCode == 200) {
        print("Response: $response");
        final String id = response.data['id'] ?? '';
        final String yearsOfExperience =
            response.data['yearsOfExperience'] ?? '0';

        // 🌟 رجعناهم كـ Record في قوسين
        return (id, yearsOfExperience);
      } else {
        throw 'Server Error: ${response.statusCode}';
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<CvData> getCandidateCv(String candidateId) async {
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.getCandidateCv(candidateId),
      );
      if (response.statusCode == 200) {
        print("Response: $response");
        return CvDataModel.fromJson(response.data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        print('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        print('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        print('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }
}
