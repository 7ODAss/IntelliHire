import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';

import '../../../../core/enums/request.dart';
import '../../../../core/network/error_message_model.dart';
import '../../../../core/utils/apis/api_constant.dart';
import '../../../../core/utils/apis/dio_config.dart';
import '../../models/sign_up_company_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  //Company Information
  final List<String> industries = [
    'Software Engineering & Development',
    'Data & Artificial Intelligence',
    'IT Infrastructure & Security',
    'Hardware & Embedded Systems',
    'Enterprise Systems & Solutions',
    'IT Services & Consulting',
  ];

  //Company Location
  final List<String> countries = [
    'Egypt',
    'Saudi Arabia',
    'UAE',
    'Kuwait',
    'Qatar',
  ];
  final Map<String, List<String>> countryGovernorates = {
    'Egypt': [
      'Alexandria',
      'Aswan',
      'Asyut',
      'Beheira',
      'Beni Suef',
      'Cairo',
      'Dakahlia',
      'Damietta',
      'Fayoum',
      'Gharbia',
      'Giza',
      'Ismailia',
      ' Kafr El Sheikh',
      'Luxor',
      'Matrouh',
      'Minya',
      'Monofiya',
      'New Valley',
      'North Sinai',
      'Port Said',
      'Qalioubiya',
      'Qena',
      'Red Sea',
      'Sharqia',
      'Sohag',
      'South Sinai',
      'Suez',
    ],
    'Saudi Arabia': [
      'Makkah',
      'Riyadh',
      'Eastern',
      'Madinah',
      'Asir',
      'Tabuk',
      'Jazan',
      'Al-Qassim',
      'Ha\'il',
      'Northern Borders',
      'Najran',
      'Al-Bahah',
    ],
    'UAE': [
      'Abu Dhabi',
      'Dubai',
      'Sharjah',
      'Ajman',
      'Umm Al Quwain',
      'Ras Al Khaimah',
      'Fujairah',
    ],
    'Kuwait': [
      'Al Asimah',
      'Hawalli',
      'Farwaniya',
      'Mubarak Al-Kabeer',
      'Ahmadi',
      'Jahra',
    ],
    'Qatar': [
      'Doha',
      'Al Rayyan',
      'Al Wakrah',
      'Al Khor',
      'Al Shamal',
      'Umm Salal',
      'Al Daayen',
      'Al Shahaniya',
    ],
  };

  //company location
  SignUpCubit() : super(const SignUpState());

  void completeInformationCompany({
    required String phoneNumber,
    required String companyName,
    required String industry,
  }) {
    emit(
      state.copyWith(
        workPhone: phoneNumber,
        companyName: companyName,
        industry: industry,
      ),
    );
  }

  void completeLocationCompany({
    required String country,
    required String gov,
    required String address,
  }) {
    emit(state.copyWith(country: country, gov: gov, address: address));
  }

  void setCountryName(String country) {
    emit(state.copyWith(country: country));
  }

  void setGovernorateName(String governorate) {
    emit(state.copyWith(gov: governorate));
  }

  void changePasswordSuffix() {
    emit(state.copyWith(changePasswordSuffix: !state.changePasswordSuffix));
  }

  void changeConfirmPasswordSuffix() {
    emit(
      state.copyWith(
        changeConfirmPasswordSuffix: !state.changeConfirmPasswordSuffix,
      ),
    );
  }

  void changeCheckBoxTermsConditions() {
    emit(
      state.copyWith(checkBoxTermsConditions: !state.checkBoxTermsConditions),
    );
  }

  void changeSelectedIndustry(String industry) {
    emit(state.copyWith(selectedIndustry: industry));
  }

  void changeSelectedCountry(String country) {
    emit(state.copyWith(selectedCountry: country));
  }

  void changeSelectedGovernorate(String governorate) {
    emit(state.copyWith(selectedGovernorate: governorate));
  }

  void changeCurrentScreen(int screen) {
    emit(state.copyWith(currentScreen: screen));
  }

  void nextStep() {
    if (state.currentScreen < 2) {
      changeCurrentScreen(state.currentScreen + 1);
    }
  }

  void previousStep() {
    if (state.currentScreen > 0) {
      changeCurrentScreen(state.currentScreen - 1);
    }
  }

  SignUpCompanyModel? signUpCompanyModel;

  void signUpCompany({
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    emit(state.copyWith(signUpState: RequestState.loading));
    DioConfig.postData(
          path: ApiConstant.registerCompany,
          data: {
            "email": email,
            "password": password,
            "confirmPassword": confirmPassword,
            "deviceName": "mobile",
          },
        )
        .then((value) async {
          signUpCompanyModel = SignUpCompanyModel.fromJson(value.data);

          if (signUpCompanyModel?.token != null &&
              signUpCompanyModel!.token.isNotEmpty) {
            await CacheHelper.saveData(
              key: 'userType',
              value: signUpCompanyModel!.userType,
            );
          }
          emit(
            state.copyWith(
              signUpState: RequestState.success,
              signUpCompanyModel: signUpCompanyModel,
              signUpMessage: signUpCompanyModel!.message,
            ),
          );
        })
        .catchError((error) {
          print('Sign Up Error: $error');
          String message = 'Login failed. Please try again.';

          if (error is DioException && error.response != null) {
            final errorData = error.response!.data;
            if (errorData is Map<String, dynamic>) {
              message =
                  ErrorMessageModel.fromJson(errorData).message ?? message;
            } else if (errorData is String) {
              message = errorData;
            }
          }
          emit(
            state.copyWith(
              signUpState: RequestState.error,
              signUpMessage: message,
            ),
          );
        });
  }

  void completeSignUp({
    String? aboutCompany,
    String? companyLogo,
    String? linkCompany,
  }) async {
    emit(state.copyWith(completeSignUpState: RequestState.loading));
    MultipartFile? logoFile;
    if (companyLogo != null &&
        companyLogo.isNotEmpty &&
        companyLogo != 'skipped') {
      logoFile = await MultipartFile.fromFile(
        companyLogo,
        filename: companyLogo.split('/').last, // بياخد اسم الملف الحقيقي
      );
    }

    final formData = FormData.fromMap({
      "Name": state.companyName,
      "WebsiteUrl": linkCompany == 'skipped' ? '' : linkCompany,
      "About": aboutCompany == 'skipped' ? '' : aboutCompany,
      "Industry": state.industry,
      "PhoneNumber": state.workPhone,
      "CompanyLogo": logoFile,
      "Locations.Country": state.country,
      "Locations.Government": state.gov,
      "Locations.City": state.address,
    });

    DioConfig.postData(path: ApiConstant.companyComplete, formData: formData)
        .then((value) async {
          print('Complete SignUp Success: ${value.data}');
          emit(
            state.copyWith(
              completeSignUpState: RequestState.success,
              completeSignUpMessage:
                  value.data['message'] ?? 'Profile completed successfully!',
            ),
          );
        })
        .catchError((error) {
          String message = 'Signup failed. Please try again.';

          if (error is DioException && error.response != null) {
            final errorData = error.response!.data;
            if (errorData is Map<String, dynamic>) {
              // لو الإيرور راجع JSON سليم
              message =
                  ErrorMessageModel.fromJson(errorData).message ?? message;
            } else if (errorData is String) {
              // لو الإيرور راجع نص عادي
              message = errorData;
            }
          }

          emit(
            state.copyWith(
              completeSignUpState: RequestState.error,
              completeSignUpMessage: message,
            ),
          );
        });
  }

  void confirmEmail({required String userId, required String token}) {
    emit(state.copyWith(confirmEmailState: RequestState.loading));

    DioConfig.getData(
          path: ApiConstant.confirmEmail, // اللينك بتاع الـ API
          queryParameters: {'userId': userId, 'token': token},
        )
        .then((value) async {
          print('Confirm Email Success: ${value.data}');

          String token = value.data['token'];
          String refreshToken = value.data['refreshToken'];
          String expiresOn = value.data['expiresOn'];
          String userType = value.data['userType'];

          await CacheHelper.saveData(key: 'token', value: token);
          await CacheHelper.saveData(key: 'refreshToken', value: refreshToken);
          await CacheHelper.saveData(key: 'expiresOn', value: expiresOn);
          await CacheHelper.saveData(key: 'userType', value: userType);

          emit(
            state.copyWith(
              confirmEmailState: RequestState.success,
              confirmEmailMessage: value.data['message'],
            ),
          );
        })
        .catchError((error) {
          print('Confirm Email Error: $error');
          emit(
            state.copyWith(
              confirmEmailState: RequestState.error,
              confirmEmailMessage: error.toString(),
            ),
          );
        });
  }
}
