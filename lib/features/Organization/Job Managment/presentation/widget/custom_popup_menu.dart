import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/job_model.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/post_job_view.dart';

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key, required this.job});
  final JobModel job;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xffAFAFAF), width: 1),
      ),
      constraints: const BoxConstraints.tightFor(width: 100),
      onSelected: (String value) {
        if (value == 'edit') {
          context.read<PostJobCubit>().loadJobForEdit(job);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                value: context.read<PostJobCubit>(),
                child: const PostJobView(),
              ),
            ),
          );
        } else if (value == 'delete') {
          context.read<JobManagementCubit>().deleteJob(job.id);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          height: 30,
          value: 'edit',
          child: Row(
            children: [
              SvgPicture.asset("assets/image/icon svg/edit.svg"),
              const SizedBox(width: 12),
              Text(
                'Edit Job',
                style: AppTextStyle.textstyle12.copyWith(
                  color: Color(0xff475569),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          height: 30,
          value: 'delete',
          textStyle: AppTextStyle.textstyle12,
          child: Row(
            children: [
              SvgPicture.asset("assets/image/icon svg/delete.svg"),
              const SizedBox(width: 15),
              Text(
                'Delete ',
                style: AppTextStyle.textstyle12.copyWith(
                  color: Color(0xffDC2626),
                ),
              ),
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_vert, color: Colors.black),
    );
  }
}
