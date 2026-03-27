
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intelli_hire/core/helpers/cache_helper.dart';

import '../../../core/enums/request.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/apis/api_constant.dart';
import '../../../core/utils/apis/dio_config.dart';
import '../models/sign_up_company_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  //Work Information
  final TextEditingController workEmailController = TextEditingController();
  final TextEditingController workPasswordController = TextEditingController();
  final TextEditingController workPhoneController = TextEditingController();
  final GlobalKey<FormState> workFormKey = GlobalKey<FormState>();

  //Company Information
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final GlobalKey<FormState> industryFormKey = GlobalKey<FormState>();
  final List<String> industries = [
    'Software Engineering & Development',
    'Data & Artificial Intelligence',
    'IT Infrastructure & Security',
    'Hardware & Embedded Systems',
    'Enterprise Systems & Solutions',
    'IT Services & Consulting',
  ];

  //Company Location
  final TextEditingController countryController = TextEditingController();
  final TextEditingController govController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> locationFormKey = GlobalKey<FormState>();

  final SearchController searchCountryController = SearchController();
  final SearchController searchGovController = SearchController();
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
  final TextEditingController linkCompanyController = TextEditingController();
  final GlobalKey<FormState> linkCompanyFormKey = GlobalKey<FormState>();

  SignUpCubit() : super(const SignUpState());

  void changeSuffix() {
    emit(state.copyWith(changeSuffix: !state.changeSuffix));
  }

  void changeCheckBoxTermsConditions() {
    emit(
      state.copyWith(checkBoxTermsConditions: !state.checkBoxTermsConditions),
    );
  }

  void changeSelectedIndustry(String industry) {
    industryController.text = industry;
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

  void clearAllControllers() {
    companyNameController.clear();
    industryController.clear();
    countryController.clear();
    govController.clear();
    addressController.clear();
    searchCountryController.clear();
    searchGovController.clear();
    linkCompanyController.clear();
    emit(
      state.copyWith(
        currentScreen: 0,
        selectedIndustry: '',
        selectedCountry: '',
        selectedGovernorate: '',
      ),
    );
  }

  bool validateCurrentStep() {
    switch (state.currentScreen) {
      case 0:
        return industryFormKey.currentState?.validate() ?? false;
      case 1:
        return locationFormKey.currentState?.validate() ?? false;
      case 2:
        return linkCompanyFormKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  SignUpCompanyModel? signUpCompanyModel;

  void signUpCompany({
    required String email,
    required String password,
    required String phoneNumber,
    required String companyName,
    required String industry,
    required String country,
    required String gov,
    required String address,
    required String linkCompany,
  }) {
    emit(state.copyWith(signUpState: RequestState.loading));
    DioConfig.postData(
          path: ApiConstant.registerCompany,
          data: {
            "email": email,
            "password": password,
            "name": companyName,
            "websiteUrl": linkCompany,
            "industry": industry,
            "phoneNumbers": phoneNumber,
            "locations": {
              "country": country,
              "government": gov,
              "city": address,
            },
            "deviceName": "mobile",
          },
        )
        .then((value) async {
          signUpCompanyModel = SignUpCompanyModel.fromJson(value.data);

          if (signUpCompanyModel?.token != null &&
              signUpCompanyModel!.token.isNotEmpty) {
            await CacheHelper.saveData(
              key: 'token',
              value: signUpCompanyModel!.token,
            );
            await CacheHelper.saveData(
              key: 'refreshToken',
              value: signUpCompanyModel!.refreshToken,
            );
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
          String message =
              ErrorMessageModel.fromJson(error.response!.data).message ??
              'Login failed. Please try again.';

          emit(
            state.copyWith(
              signUpState: RequestState.error,
              signUpMessage: message,
            ),
          );
        });
  }
}
