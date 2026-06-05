import 'package:flutter/material.dart';

class ApiConstant {
  static const String baseUrl = 'https://intellhire.runasp.net/api';

  //auth
  static const String login = '$baseUrl/Auth/login';
  static const String registerCompany = '$baseUrl/Auth/register/company';
  static const String companyComplete = '$baseUrl/Profile/CompanyComplete';
  static const String confirmEmail = '$baseUrl/Auth/confirm-email';
  static const String refreshToken = '$baseUrl/Auth/refresh-token';
  static const String logout = "$baseUrl/Auth/logout";
  static const String checkEmail = "$baseUrl/Auth/forget-password-request";
  static const String verifyOtp = "$baseUrl/Auth/send-otp";
  static const String resetPassword = "$baseUrl/Auth/reset-password";

  static String externalLogin(String provider, String userType) =>
      "$baseUrl/Auth/external-login?provider=$provider&type=$userType&returnUrl=CustomBottomNavBarWrapper&rememberMe=false";

  //candidate
  //home
  static const String candidateDashboard = "$baseUrl/User/mobile-dashboard";
  static const String candidateDashboardNext =
      "$baseUrl/User/mobile-dashboard/next";
  static const String candidateDashboardPrev =
      "$baseUrl/User/mobile-dashboard/prev";
  static const String candidateDashboardReset =
      "$baseUrl/User/mobile-dashboard/reset";
  //assess history
  static const String candidateAssessmentHistory =
      "$baseUrl/User/mobile-assessments";
  static const String candidateAssessmentSubmit =
      "$baseUrl/User/mobile-assessments/submit";
  static String candidatePerformanceReport(String assessmentId) =>
      "$baseUrl/User/mobile-assessments/report/$assessmentId";

  //new assess

  static const String getCandidateId = "$baseUrl/User/profile";
  static String getCandidateCv(String id) =>
      "$baseUrl/User/professional-profile/$id";

  //candidate profile
  static const String candidateProfile = "$baseUrl/Setting/account";
  static const String candidateChangePersonalInfoProfile =
      "$baseUrl/Setting/personal-info";
  static const String candidateChangePassword =
      "$baseUrl/settings/update-password";
  static const String candidateDeleteAccount =
      "$baseUrl/Setting/delete-account";
  static const String candidateChangeCareerDetails =
      "$baseUrl/Setting/career-details";

  static const String candidateChangeEmailVerifyPass =
      "$baseUrl/Setting/change-email-password-request";

  static const String candidateChangeEmailRequestOtp =
      "$baseUrl/Setting/change-email-request";

  static const String candidateChangeEmailConfirmOtp =
      "$baseUrl/Setting/change-email-Confirm";

  static const String candidateChangePasswordOtpRequest =
      "$baseUrl/Setting/request-password-change";

  static const String candidateChangePasswordOtpCheck =
      "$baseUrl/Setting/send-otp";

  static const String candidateChangePasswordVerify =
      "$baseUrl/Setting/confirm-password-change";

  //company profile
  static const String companyChangePassword =
      "$baseUrl/candidate/settings/security/change-password";
  static const String companyDeleteAccount =
      "$baseUrl/candidate/settings/security/delete-account";

  //keys
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
