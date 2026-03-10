import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Post Job/presentation/widget/cancel_dialog.dart';
import '../models/company_location_model.dart';
import '../widgets/delete_account_confirm_dialog.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState());

  // Personal Info
  final TextEditingController emailController = TextEditingController(
      text: 'mahmoud.m@gmail.com');
  final TextEditingController phoneController = TextEditingController(
      text: '0 100 123 4567');
  final GlobalKey<FormState> personalInfoKey = GlobalKey<FormState>();

  // Security
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final GlobalKey<FormState> securityInfoKey = GlobalKey<FormState>();

  // Company Details
  final GlobalKey<FormState> companyDetailsKey = GlobalKey<FormState>();
  final TextEditingController companyNameController = TextEditingController(
      text: 'IntelliHire');
  final TextEditingController industryController = TextEditingController(
      text: 'Information Technology');
  final TextEditingController websiteController = TextEditingController(
      text: 'www.intellihire.com');

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

  final List<String> industries = [
    'Software Engineering & Development',
    'Data & Artificial Intelligence',
    'IT Infrastructure & Security',
    'Hardware & Embedded Systems',
    'Enterprise Systems & Solutions',
    'IT Services & Consulting',
  ];

  final TextEditingController linkCompanyController = TextEditingController();

  void addCompanyLocation() {
    if (countryController.text.isNotEmpty && govController.text.isNotEmpty &&
        addressController.text.isNotEmpty){
      final newLocation = CompanyLocationModel(
        country: countryController.text,
        governorate: govController.text,
        address: addressController.text,
      );

      final currentLocations=state.locations ?? [];

      final updatedLocation = [...currentLocations,newLocation];

      countryController.clear();
      govController.clear();
      addressController.clear();

      emit(state.copyWith(
        locations: updatedLocation,
        selectedCountry: '',
        selectedGovernorate: '',
      ));
    }
  }

  void removeCompanyLocation(int index) {
    final currentLocations = state.locations ?? [];
    final List<CompanyLocationModel> updatedLocations = List.from(currentLocations);
    updatedLocations.removeAt(index);
    emit(state.copyWith(locations: updatedLocations));
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: this,
          child: const DeleteAccountConfirmDialog(),
        );
      },
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

}
