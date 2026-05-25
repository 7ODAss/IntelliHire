import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/presentation/controller/job_management_cubit/job_management_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_cubit.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/post_job_view.dart';
import 'package:intelli_hire/features/Organization/bottom%20_navigation/controller/bottom_nav_cubit.dart'; 

class CustomPopupMenu extends StatelessWidget {
  const CustomPopupMenu({super.key, required this.job});
  
  final JobItemEntity job; 

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xffAFAFAF), width: 1),
      ),
      constraints: const BoxConstraints.tightFor(width: 120), // زودنا العرض شوية عشان الكلام
      onSelected: (String value) {
        if (value == 'edit') {
          // 🔴 التعديل السحري هنا:
          // بننادي على الدالة اللي بتروح تجيب "الزتونة" (التفاصيل الكاملة) بالـ ID
          context.read<PostJobCubit>().fetchAndLoadJobForEdit(job.id); 
          
          // بنفتح الشاشة، وبما إننا نادينا على fetchAndLoadJobForEdit، 
          // الشاشة هتفتح وتوري المستخدم Loader لحد ما الداتا الكاملة توصل
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (newContext) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<PostJobCubit>(),
                  ),
                  BlocProvider.value(
                    value: context.read<JobManagementCubit>(),
                  ),
                  BlocProvider.value(
                    value: context.read<BottomNavCubit>(),
                  ),
                ],
                child: const PostJobView(),
              ),
            ),
          );
        } else if (value == 'delete') {
          // كود المسح اللي ظبطناه سوا
          context.read<JobManagementCubit>().deleteJob(job.id);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          height: 35,
          value: 'edit',
          child: Row(
            children: [
              SvgPicture.asset("assets/image/icon svg/edit.svg"),
              const SizedBox(width: 12),
              Text(
                'Edit Job',
                style: AppTextStyle.textstyle12.copyWith(
                  color: const Color(0xff475569),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          height: 35,
          value: 'delete',
          child: Row(
            children: [
              SvgPicture.asset("assets/image/icon svg/delete.svg"),
              const SizedBox(width: 12),
              Text(
                'Delete',
                style: AppTextStyle.textstyle12.copyWith(
                  color: const Color(0xffDC2626),
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