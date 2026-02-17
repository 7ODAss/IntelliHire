import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  //Work Information
  final TextEditingController workEmailController = TextEditingController();
  final TextEditingController workPasswordController = TextEditingController();
  final TextEditingController workPhoneController = TextEditingController();
  final GlobalKey<FormState> workFormKey = GlobalKey<FormState>();
  //Company Information
  final TextEditingController companyNameController = TextEditingController();
  final GlobalKey<FormState> industryFormKey = GlobalKey<FormState>();
  final List<String> industries = [
    'Software Engineering & Development',
    'Data & Artificial Intelligence',
    'IT Infrastructure & Security',
    'Hardware & Embedded Systems',
    'Enterprise Systems & Solutions',
    'IT Services & Consulting',
  ];
  String? selectedIndustry;
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
      'Dakahlia' ,
      'Damietta' ,
      'Fayoum' ,
      'Gharbia' ,
      'Giza' ,
      'Ismailia' ,
      ' Kafr El Sheikh',
      'Luxor' ,
      'Matrouh' ,
      'Minya' ,
      'Monofiya' ,
      'New Valley',
      'North Sinai' ,
      'Port Said' ,
      'Qalioubiya',
      'Qena',
      'Red Sea',
      'Sharqia',
      'Sohag',
      'South Sinai',
      'Suez' ,
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
    emit(state.copyWith(checkBoxTermsConditions: !state.checkBoxTermsConditions));
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
    selectedIndustry = null;
    countryController.clear();
    govController.clear();
    addressController.clear();
    searchCountryController.clear();
    searchGovController.clear();
    linkCompanyController.clear();
    emit(state.copyWith(
      currentScreen: 0,
      selectedCountry: '',
      selectedGovernorate: '',
    ));
  }
  bool validateCurrentStep() {
    switch (state.currentScreen) {
      case 0:

        return industryFormKey.currentState?.validate() ?? false;
      case 1:
        // if (countryController.text.isEmpty) return false;
        // if (govController.text.isEmpty) return false;
        return locationFormKey.currentState?.validate() ?? false;
      case 2:
        //if (linkCompanyController.text.isEmpty) return false;
        return linkCompanyFormKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }
}
