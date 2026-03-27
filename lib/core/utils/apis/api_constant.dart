class ApiConstant {
  static const String baseUrl = 'https://10.0.2.2:7257/api';
  //static const String baseUrl = 'https://nondominating-supergenerically-ronnie.ngrok-free.dev/api';
  static const String login = '$baseUrl/Auth/login';
  static const String registerCompany = '$baseUrl/Auth/register/company';

  static String externalLogin(String provider, String userType) =>
      "$baseUrl/Auth/external-login?provider=$provider&type=$userType&returnUrl=CustomBottomNavBarWrapper&rememberMe=false";

  static const String logout = "$baseUrl/Auth/logout";
  static const String userProfile = "$baseUrl/User/profile/";
}