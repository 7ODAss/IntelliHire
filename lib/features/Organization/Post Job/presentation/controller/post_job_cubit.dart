import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart'; // 🟢 استيراد الـ getIt
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_cubit.dart'; // 🟢 استيراد الـ HomeCubit
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_job_details_usecase.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/cancel_dialog.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/usecases/post_job_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/update_job_usecase.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/usecases/get_company_locations_usecase.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/entities/location_entity.dart';

class PostJobCubit extends Cubit<PostJobState> {
  final PostJobUseCase postJobUseCase;
  final UpdateJobUseCase updateJobUseCase;
  final GetJobDetailsUseCase getJobDetailsUseCase;
  final GetCompanyLocationsUseCase getCompanyLocationsUseCase;

  PostJobCubit({
    required this.postJobUseCase,
    required this.updateJobUseCase,
    required this.getJobDetailsUseCase,
    required this.getCompanyLocationsUseCase,
  }) : super(PostJobInitial()) {
    getLocations();
  }

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
  List<String> addedSkills = [];
  int activeStep = 0;
  String? editingJobId;

  List<LocationEntity> companyLocations = [];
  List<String> availableLocations = [];

  bool get isEditMode => editingJobId != null;

  Future<void> getLocations() async {
    emit(GetLocationsLoading());
    final result = await getCompanyLocationsUseCase.execute();

    result.fold((errorString) => emit(GetLocationsFailure(errorString)), (
      locations,
    ) {
      companyLocations = locations;
      availableLocations = [];

      for (var loc in locations) {
        availableLocations.add(loc.formattedLocation);
      }

      if (selectedLocation != null &&
          !availableLocations.contains(selectedLocation)) {
        selectedLocation = null;
      }

      emit(GetLocationsSuccess());
    });
  }

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

  bool validateBasicInfo() => basicInfoKey.currentState?.validate() ?? false;
  bool validateSkills() => addedSkills.isNotEmpty;
  bool validateJobDesc() => jobDescKey.currentState?.validate() ?? false;

  Future<void> fetchAndLoadJobForEdit(String jobId) async {
    emit(PostJobLoading());
    final result = await getJobDetailsUseCase.execute(jobId);

    result.fold(
      (error) => emit(PostJobError(error)),
      (job) => _loadJobDataIntoFields(job),
    );
  }

  void _loadJobDataIntoFields(JobItemEntity job) {
    reset();
    editingJobId = job.id;
    titleController.text = job.title;

    selectedLocation = job.location;
    if (selectedLocation != null && selectedLocation!.isNotEmpty) {
      if (!availableLocations.contains(selectedLocation)) {
        availableLocations.add(selectedLocation!);
      }
    }

    descController.text = job.description ?? '';
    reqController.text = job.requirements ?? '';
    selectedCareerLevel = job.careerLevel;

    if (job.experienceYears != null) {
      selectedExperience =
          "${job.experienceYears} to ${job.experienceYears! + 2} Years";
    }

    addedSkills = List<String>.from(job.requiredSkills ?? []);

    String lowerType = job.type.toLowerCase();
    if (lowerType.contains("full")) {
      selectedJobType = 0;
    } else if (lowerType.contains("part")) {
      selectedJobType = 1;
    } else if (lowerType.contains("remote")) {
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

  void showDiscardDialog(BuildContext context) async {
    final shouldCloseScreen = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) =>
          BlocProvider.value(value: this, child: const CancelDialog()),
    );
    if (shouldCloseScreen == true && context.mounted) Navigator.pop(context);
  }

  Future<void> submitJob() async {
    if (!validateJobDesc()) return;
    emit(PostJobLoading());

    String jobTypeText = "Full Time";
    if (selectedJobType == 1) jobTypeText = "Part Time";
    if (selectedJobType == 2) jobTypeText = "Remote";

    int expYears = 0;
    if (selectedExperience != null)
      expYears = int.tryParse(selectedExperience!.split(' ').first) ?? 0;

    final jobData = {
      "title": titleController.text.trim(),
      "careerLevel": selectedCareerLevel ?? "Junior",
      "experienceYears": expYears,
      "type": jobTypeText,
      "location": selectedLocation ?? "No location",
      "requiredSkills": addedSkills.join(", "),
      "description": descController.text.trim(),
      "requirements": reqController.text.trim(),
    };

    final result = isEditMode
        ? await updateJobUseCase.execute(editingJobId!, jobData)
        : await postJobUseCase.execute(jobData);

    result.fold((error) => emit(PostJobError(error)), (_) {
      emit(PostJobSuccess());
      getIt<HomeOrganizationCubit>().fetchDashboard();

      reset();
    });
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
