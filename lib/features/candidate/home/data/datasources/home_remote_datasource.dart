import 'package:dio/dio.dart';
import 'package:intelli_hire/core/utils/apis/dio_config.dart';
import 'package:intelli_hire/features/candidate/home/data/models/home_summary_model.dart';
import '../../../../../core/utils/apis/api_constant.dart';
import '../models/weekly_activity_summary_model.dart';

abstract class BaseHomeDataSource {
  Future<HomeSummaryModel> getHomeSummary();
  Future<WeeklyActivitySummaryModel> getNextWeek();
  Future<WeeklyActivitySummaryModel> getPrevWeek();
  Future<WeeklyActivitySummaryModel> resetWeek();
}

class HomeRemoteDataSource implements BaseHomeDataSource {
  @override
  Future<HomeSummaryModel> getHomeSummary() async {
    try {
      final response = await DioConfig.getData(
        path: ApiConstant.candidateDashboard,
      );
      if (response.statusCode == 200) {
        print('✅ داتا السيرفر: ${response.data}');
        return HomeSummaryModel.fromJson(response.data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
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
  Future<WeeklyActivitySummaryModel> getNextWeek() async{
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateDashboardNext,
      );
      if (response.statusCode == 200) {
        print('✅ داتا السيرفر: ${response.data}');
        return WeeklyActivitySummaryModel.fromJson(response.data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
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
  Future<WeeklyActivitySummaryModel> getPrevWeek() async{
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateDashboardPrev,
      );
      if (response.statusCode == 200) {
        print('✅ داتا السيرفر: ${response.data}');
        return WeeklyActivitySummaryModel.fromJson(response.data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
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
  Future<WeeklyActivitySummaryModel> resetWeek() async{
    try {
      final response = await DioConfig.postData(
        path: ApiConstant.candidateDashboardReset,
      );
      if (response.statusCode == 200) {
        print('✅ داتا السيرفر: ${response.data}');
        return WeeklyActivitySummaryModel.fromJson(response.data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
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
}