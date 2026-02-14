import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../presentation/login/widget/candidate_page.dart';
import '../presentation/login/widget/company_page.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());
  final TextEditingController candidateEmailController = TextEditingController();
  final TextEditingController candidatePasswordController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final TextEditingController companyPasswordController = TextEditingController();
  final PageController loginPageController = PageController();
  final GlobalKey<FormState> candidateFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> companyFormKey = GlobalKey<FormState>();
  final List<String> title = ['Candidate', 'Recruiter'];
  final List<Widget> pages = [CandidatePage(), CompanyPage()];


  void changeIndex(int index) {
      emit(state.copyWith(currentIndex:index));
  }

  void changeSuffix() {
    emit(state.copyWith(changeSuffix:!state.changeSuffix));
  }
}