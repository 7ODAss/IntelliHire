import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/Organization/Home/domain/entities/home_entity.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_cubit.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_state.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_state.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/empty_home_body.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/current_job_list_view.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/current_jobs_header.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/top_canddidate_card.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/views/widget/top_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrganizationHomeView extends StatelessWidget {
  const OrganizationHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<HomeOrganizationCubit>()..fetchDashboard()),
        BlocProvider(create: (context) => getIt<JobManagementCubit>()),
      ],
      child: Scaffold(
        body: BlocListener<JobManagementCubit, JobManagementState>(
          listener: (context, state) {
            if (state is JobDeletedSuccess) {
              context.read<HomeOrganizationCubit>().fetchDashboard();
            }
          },
          child: BlocBuilder<HomeOrganizationCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<HomeOrganizationCubit>().fetchDashboard(),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              final bool isLoading =
                  state is HomeLoading || state is HomeInitial;

              final HomeEntity data = isLoading
                  ? HomeEntity(
                      companyName: "Loading Name",
                      interviewsCount: 0,
                      totalCandidates: 0,
                      pendingCandidates: 0,
                      topTalentCandidatesCount: 0,
                      topTalentInterviewsCount: 0,
                      jobs: List.generate(
                        3,
                        (index) => DashboardJobEntity(
                          id: "loading$index",
                          title: "Loading Job Title",
                          postedAt: "Loading",
                          acceptedCount: 0,
                          rejectedCount: 0,
                        ),
                      ),
                    )
                  : (state as HomeLoaded).dashboardData;

              final String companyName = data.companyName.isEmpty
                  ? "Company"
                  : data.companyName;

              if (!isLoading && data.jobs.isEmpty) {
                return EmptyHomeBody(companyName: companyName);
              }

              return Skeletonizer(
                enabled: isLoading,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopSection(
                        interviews: data.interviewsCount.toString(),
                        candidates: data.totalCandidates.toString(),
                        pending: data.pendingCandidates.toString(),
                        companyName: companyName,
                      ),
                      const SizedBox(height: 24),
                      TopCanddidateCard(
                        candidatesCount: data.topTalentCandidatesCount,
                        interviewsCount: data.topTalentInterviewsCount,
                      ),
                      const CurrentJobsHeader(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CurrentJobListView(jobs: data.jobs),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
