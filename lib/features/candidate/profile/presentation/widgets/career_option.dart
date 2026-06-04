import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../controller/candidate_profile_cubit.dart';
import '../screen/career_details.dart';
import 'optionfield.dart';

class CareerOption extends StatelessWidget {
  final CandidateProfileCubit cubit;

  const CareerOption({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company', style: AppTextStyle.accountNamePostScreen),
        Card(
          color: Colors.white,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptionField(
                  icon: Icons.business_outlined,
                  categoryName: 'Career Details',
                  options: ['Current role , Experience Yrs , CV'],
                  fun: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: CareerDetails(
                            currentRole:
                                cubit
                                    .state
                                    .candidateProfileModel
                                    ?.currentRole ??
                                '',
                            experienceYears:
                                cubit
                                    .state
                                    .candidateProfileModel
                                    ?.experienceYears ??
                                0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
