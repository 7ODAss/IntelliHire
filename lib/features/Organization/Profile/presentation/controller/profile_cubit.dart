import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/enums/request.dart';
import 'package:intelli_hire/core/usecase/base_usecase.dart';
import 'package:intelli_hire/features/Organization/Profile/domain/usecase/user_profile_log_out_usecase.dart';

import '../../domain/entity/company_location.dart';
import '../widgets/delete_account_confirm_dialog.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final LogOutUserProfileUseCase logOutUserProfileUseCase;
  ProfileCubit(this.logOutUserProfileUseCase) : super(ProfileState());

  // Security
  final TextEditingController currentPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final GlobalKey<FormState> securityInfoKey = GlobalKey<FormState>();


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

  void addCompanyLocation({required String detailedAddress}) {
    if (state.selectedCountry != null &&
        state.selectedGovernorate != null &&
        detailedAddress.isNotEmpty) {
      final newLocation = CompanyLocation(
        country: state.selectedCountry!,
        governorate: state.selectedGovernorate!,
        address:detailedAddress,
      );

      final currentLocations = state.locations ?? [];

      final updatedLocation = [...currentLocations, newLocation];

      emit(
        state.copyWith(
          locations: updatedLocation,
          selectedCountry: '',
          selectedGovernorate: '',
        ),
      );
    }
  }

  void removeCompanyLocation(int index) {
    final currentLocations = state.locations ?? [];
    final List<CompanyLocation> updatedLocations = List.from(currentLocations);
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

  Future<void> logout() async {
    emit(state.copyWith(userProfileLogOutState: RequestState.loading));
    final result = await logOutUserProfileUseCase(NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          userProfileLogOutMessage: l.message,
          userProfileLogOutState: RequestState.error,
        ),
      ),
      (r) => emit(
        state.copyWith(
          userProfileLogOutState: RequestState.success,
        ),
      ),
    );
  }
}
