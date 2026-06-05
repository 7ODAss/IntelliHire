import 'package:dio/dio.dart';
import 'package:intelli_hire/core/utils/apis/api_constant.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import '../models/assessment_model.dart';
import '../models/performance_report_model.dart';

abstract class BaseAssessManageDataSource {
  Future<List<AssessmentModel>> fetchAssessmentHistory();
  Future<PerformanceReportModel> fetchPerformanceReport(String assessmentId);
}
class AssessManageRemoteDataSource implements BaseAssessManageDataSource {

  @override
  Future<List<AssessmentModel>> fetchAssessmentHistory() async {
   try{
     final response = await DioConfig.getData(path: ApiConstant.candidateAssessmentHistory);
     if (response.statusCode == 200) {
       return List<AssessmentModel>.from(response.data.map((e)=>AssessmentModel.fromJson(e)));
     }else {
       throw Exception('Server Error: ${response.statusCode}');
     }
   }catch (e) {
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
  Future<PerformanceReportModel> fetchPerformanceReport(
    String assessmentId,
  ) async {
    try{
      final response = await DioConfig.getData(path: ApiConstant.candidatePerformanceReport(assessmentId));
      if (response.statusCode == 200) {
        print('performance report: ${response.data}');
        return PerformanceReportModel.fromJson(response.data);
      }else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    }catch (e) {
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
}
