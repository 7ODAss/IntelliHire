import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/models/job_model.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/cancel_dialog.dart';

class PostJobCubit extends Cubit<PostJobState> {
  PostJobCubit() : super(PostJobInitial());

  final GlobalKey<FormState> basicInfoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> skillsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> jobDescKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController reqController = TextEditingController();

  int selectedJobType = -1;
  String? selectedCareerLevel;
  String? selectedExperience;
  String? selectedLocation;

  void showDiscardDialog(BuildContext context) async {
    final shouldCloseScreen = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(value: this, child: const CancelDialog());
      },
    );

    if (shouldCloseScreen == true && context.mounted) {
      Navigator.pop(context);
    }
  }

  void updateJobType(int index) {
    selectedJobType = index;
    emit(PostJobUpdated());
  }

  void updateCareerLevel(String? value) {
    selectedCareerLevel = value;
    emit(PostJobUpdated());
  }

  void updateExperience(String? value) {
    selectedExperience = value;
    emit(PostJobUpdated());
  }

  void updateLocation(String? value) {
    selectedLocation = value;
    emit(PostJobUpdated());
  }

  List<String> addedSkills = [];

  void addSkill() {
    String newSkill = skillController.text.trim();
    if (newSkill.isNotEmpty && !addedSkills.contains(newSkill)) {
      addedSkills.add(newSkill);
      skillController.clear();
      emit(PostJobUpdated());
    }
  }

  void removeSkill(String skill) {
    addedSkills.remove(skill);
    emit(PostJobUpdated());
  }

  int activeStep = 0;

  void nextStep() {
    if (activeStep < 2) {
      activeStep++;
      emit(PostJobUpdated());
    }
  }

  void previousStep() {
    if (activeStep > 0) {
      activeStep--;
      emit(PostJobUpdated());
    }
  }

  bool validateBasicInfo() {
    bool isTextValid = basicInfoKey.currentState?.validate() ?? false;
    bool isDropdownsValid =
        selectedCareerLevel != null &&
        selectedExperience != null &&
        selectedLocation != null;
    bool isJobTypeValid = selectedJobType != -1;

    return isTextValid && isDropdownsValid && isJobTypeValid;
  }

  bool validateSkills() {
    return addedSkills.isNotEmpty;
  }

  bool validateJobDesc() {
    return jobDescKey.currentState?.validate() ?? false;
  }

  String? editingJobId;

  void loadJobForEdit(JobModel job) {
    editingJobId = job.id;
    titleController.text = job.title;
    selectedLocation = job.location;
    descController.text = job.description ?? '';
    reqController.text = job.requirements ?? '';
    selectedCareerLevel = job.careerLevel;
    selectedExperience = job.experience;
    addedSkills = List.from(job.skills ?? []);

    if (job.jobType == "Full Time") {
      selectedJobType = 0;
    } else if (job.jobType == "Part Time") {
      selectedJobType = 1;
    } else if (job.jobType == "Remote") {
      selectedJobType = 2;
    }

    emit(PostJobUpdated());
  }

  void reset() {
    titleController.clear();
    skillController.clear();
    descController.clear();
    reqController.clear();
    editingJobId = null;

    selectedJobType = -1;
    selectedCareerLevel = null;
    selectedExperience = null;
    selectedLocation = null;
    addedSkills.clear();
    activeStep = 0;

    emit(PostJobInitial());
  }

  @override
  Future<void> close() {
    titleController.dispose();
    skillController.dispose();
    descController.dispose();
    reqController.dispose();
    return super.close();
  }
}
