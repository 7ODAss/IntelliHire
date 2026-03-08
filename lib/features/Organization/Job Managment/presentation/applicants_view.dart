import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/appliocants_cubit/applicants_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/applicant_card.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/custom_pop_button.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/widget/filter_chip.dart';

class ApplicantsScreen extends StatelessWidget {
  const ApplicantsScreen({super.key});

  final List<String> filters = const [
    "All",
    "Top Rated",
    "Pending",
    "Accepted",
    "Rejected",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicantsCubit, ApplicantsState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 55),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomPopButton(),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Applicants",
                          style: AppTextStyle.textstyle20.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColor.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Senior React Developer",
                          style: AppTextStyle.textstyle12.copyWith(
                            color: const Color(0xff475569),
                          ),
                        ),
                      ],
                    ),
                    // 🌟 ده زرار الداتا الوهمية (هتمسحه لما تخلص اختبار)
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        context.read<ApplicantsCubit>().addDummyApplicants();
                      },
                      icon: Icon(
                        Icons.flash_on,
                        color: AppColor.primary,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: filters.map((filter) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomChoiceChip(
                        label: filter,
                        isSelected: state.selectedFilter == filter,
                        onTap: () {
                          context.read<ApplicantsCubit>().changeFilter(filter);
                        },
                        onSelected: () {},
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: state.filteredApplicants.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No applicants yet",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.filteredApplicants.length,
                        itemBuilder: (context, index) {
                          final applicant = state.filteredApplicants[index];
                          return ApplicantCard(applicant: applicant);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
