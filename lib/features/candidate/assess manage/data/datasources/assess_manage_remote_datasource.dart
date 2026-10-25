import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.candidateAssessmentHistory,
      );
      if (response.statusCode == 200) {
        debugPrint('assessment history: ${response.data}');
        return List<AssessmentModel>.from(
          response.data.map((e) => AssessmentModel.fromJson(e)),
        );
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        debugPrint('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        debugPrint('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        debugPrint('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }

  @override
  Future<PerformanceReportModel> fetchPerformanceReport(
    String assessmentId,
  ) async {
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.candidatePerformanceReport(assessmentId),
      );
      if (response.statusCode == 200) {
        debugPrint('performance report: ${response.data}');
        return PerformanceReportModel.fromJson(response.data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        // 🌟 السطر ده هيجيبلك الخلاصة وكلام السيرفر بالظبط
        debugPrint('🚨 تفاصيل رفض السيرفر (400): ${e.response?.data}');
        debugPrint('🚨 اللينك اللي راح للسيرفر: ${e.requestOptions.uri}');
      } else {
        debugPrint('🚨 خطأ غير متوقع: $e');
      }
      rethrow;
    }
  }
}
