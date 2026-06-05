import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/core/service/service_locator.dart';
import 'package:intelli_hire/features/Organization/Home/presentation/controller/home%20cubit/home_cubit_cubit.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/entities/job_entity.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/get_job_details_usecase.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/controller/post_job_state.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/presentation/widget/cancel_dialog.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/usecases/post_job_usecase.dart';
import 'package:intelli_hire/features/Organization/Job%20Managment/domain/usecases/update_job_usecase.dart';
import 'package:intelli_hire/features/Organization/Post%20Job/domain/usecases/get_company_locations_usecase.dart';

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
  }) : super(PostJobInitial());

  final GlobalKey<FormState> basicInfoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> skillsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> jobDescKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController skillController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController reqController = TextEditingController();
  final TextEditingController expController = TextEditingController();

  final TextEditingController cvCountCtrl = TextEditingController(text: '0');
  final TextEditingController codingCtrl = TextEditingController(text: '0');
  final TextEditingController behavioralCtrl = TextEditingController(text: '0');
  final TextEditingController technicalCtrl = TextEditingController(text: '0');

  int selectedJobType = -1;
  String? selectedCareerLevel;
  String? selectedCategoryLabel;
  String? selectedCategoryValue;
  String? selectedSubCategoryLabel;
  String? selectedSubCategoryValue;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  final List<Map<String, String>> jobCategories = [
    {"label": "Software Engineering", "value": "Software"},
    {"label": "Artificial Intelligence", "value": "AI"},
    {"label": "Product Management", "value": "Product"},
    {"label": "UI/UX Design", "value": "Design"},
    {"label": "Digital Marketing", "value": "Marketing"},
    {"label": "Data Science", "value": "Data"},
  ];

  final Map<String, List<Map<String, String>>> jobSubCategories = {
    "Software": [
      {"label": "Frontend Developer", "value": "Frontend"},
      {"label": "Backend Developer", "value": "Backend"},
      {"label": "Full Stack Developer", "value": "FullStack"},
      {"label": "Mobile Developer", "value": "Mobile"},
      {"label": "DevOps Engineer", "value": "DevOps"},
    ],
    "AI": [
      {"label": "Machine Learning Engineer", "value": "MachineLearning"},
      {"label": "NLP Engineer", "value": "NLP"},
      {"label": "Computer Vision Engineer", "value": "ComputerVision"},
      {"label": "AI Researcher", "value": "AIResearcher"},
      {"label": "Data Scientist", "value": "DataScientist"},
    ],
    "Product": [
      {"label": "Product Manager", "value": "ProductManager"},
      {"label": "Product Owner", "value": "ProductOwner"},
      {"label": "Scrum Master", "value": "ScrumMaster"},
    ],
    "Design": [
      {"label": "UI Designer", "value": "UIDesigner"},
      {"label": "UX Designer", "value": "UXDesigner"},
      {"label": "Product Designer", "value": "ProductDesigner"},
      {"label": "Graphic Designer", "value": "GraphicDesigner"},
    ],
    "Marketing": [
      {"label": "SEO Specialist", "value": "SEO"},
      {"label": "Content Marketer", "value": "ContentMarketing"},
      {"label": "Social Media Manager", "value": "SocialMedia"},
      {"label": "Growth Hacker", "value": "Growth"},
    ],
    "Data": [
      {"label": "Data Analyst", "value": "DataAnalyst"},
      {"label": "Data Engineer", "value": "DataEngineer"},
      {"label": "Business Intelligence", "value": "BI"},
    ],
  };

  List<String> addedSkills = [];
  int activeStep = 0;
  String? editingJobId;

  bool get isEditMode => editingJobId != null;

  void nextStep() {
    if (activeStep < 3) {
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

  void incrementCounter(TextEditingController ctrl) {
    int val = int.tryParse(ctrl.text) ?? 0;
    ctrl.text = (val + 1).toString();
    emit(PostJobUpdated());
  }

  void decrementCounter(TextEditingController ctrl) {
    int val = int.tryParse(ctrl.text) ?? 0;
    if (val > 0) {
      ctrl.text = (val - 1).toString();
      emit(PostJobUpdated());
    }
  }

  void updateCounters() {
    emit(PostJobUpdated());
  }

  void updateJobType(int index) {
    selectedJobType = index;
    emit(PostJobUpdated());
  }

  void updateCareerLevel(String? value) {
    selectedCareerLevel = value;
    emit(PostJobUpdated());
  }

  void updateCategory(String? label) {
    if (label == null) return;
    selectedCategoryLabel = label;
    selectedCategoryValue = jobCategories.firstWhere(
      (cat) => cat['label'] == label,
    )['value'];
    selectedSubCategoryLabel = null;
    selectedSubCategoryValue = null;
    emit(PostJobUpdated());
  }

  void updateSubCategory(String? label) {
    if (label == null || selectedCategoryValue == null) return;
    selectedSubCategoryLabel = label;
    selectedSubCategoryValue = jobSubCategories[selectedCategoryValue]!
        .firstWhere((sub) => sub['label'] == label)['value'];
    emit(PostJobUpdated());
  }

  List<String> getAvailableSubCategoryLabels() {
    if (selectedCategoryValue == null ||
        !jobSubCategories.containsKey(selectedCategoryValue)) return [];
    return jobSubCategories[selectedCategoryValue]!
        .map((sub) => sub['label']!)
        .toList();
  }

  void updateStartDate(DateTime date) {
    selectedStartDate = date;
    if (selectedEndDate != null && selectedEndDate!.isBefore(date)) {
      selectedEndDate = null;
    }
    emit(PostJobUpdated());
  }

  void updateEndDate(DateTime date) {
    selectedEndDate = date;
    emit(PostJobUpdated());
  }

  void addSkill() {
    String newSkill = skillController.text.trim();
    while (newSkill.endsWith(',') || newSkill.endsWith(' ')) {
      newSkill = newSkill.substring(0, newSkill.length - 1).trim();
    }
    if (newSkill.isNotEmpty) {
      final formattedSkill = '$newSkill,';
      if (!addedSkills.contains(formattedSkill)) {
        addedSkills.add(formattedSkill);
        skillController.clear();
        emit(PostJobUpdated());
      }
    }
  }

  void removeSkill(String skill) {
    addedSkills.remove(skill);
    emit(PostJobUpdated());
  }

  bool validateBasicInfo() {
    bool isFormValid = basicInfoKey.currentState?.validate() ?? false;
    bool areDropdownsValid = selectedCategoryValue != null && selectedSubCategoryValue != null;
    return isFormValid && areDropdownsValid;
  }

  bool validateSkills() => addedSkills.isNotEmpty;
  bool validateJobDesc() => jobDescKey.currentState?.validate() ?? false;

  bool processAndValidateInterviewDetails(BuildContext context) {
    if (selectedStartDate == null || selectedEndDate == null) {
      _showError(context, 'Please select both Start and End dates for the interview.');
      return false;
    }

    int coding = int.tryParse(codingCtrl.text) ?? 0;
    int behav = int.tryParse(behavioralCtrl.text) ?? 0;
    int tech = int.tryParse(technicalCtrl.text) ?? 0;
    int cvCount = int.tryParse(cvCountCtrl.text) ?? 0;

    int total = coding + behav + tech + cvCount;

    if (total < 7 || total > 20) {
      _showError(
        context,
        'The sum of all counters must be between 7 and 20. Current total is $total.',
      );
      return false;
    }

    return true;
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void reset() {
    titleController.clear();
    skillController.clear();
    descController.clear();
    reqController.clear();
    expController.clear();
    cvCountCtrl.text = '0';
    codingCtrl.text = '0';
    behavioralCtrl.text = '0';
    technicalCtrl.text = '0';
    editingJobId = null;
    selectedJobType = -1;
    selectedCareerLevel = null;
    selectedCategoryLabel = null;
    selectedCategoryValue = null;
    selectedSubCategoryLabel = null;
    selectedSubCategoryValue = null;
    selectedStartDate = null;
    selectedEndDate = null;
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

  Future<void> submitJob(BuildContext context) async {
    if (!processAndValidateInterviewDetails(context)) return;

    emit(PostJobLoading());

    String jobTypeText = "Full Time";
    if (selectedJobType == 1) jobTypeText = "Part Time";
    if (selectedJobType == 2) jobTypeText = "Remote";
    int expYears = int.tryParse(expController.text.trim()) ?? 0;

    final Map<String, dynamic> jobData = {
      "title": titleController.text.trim(),
      "category": selectedCategoryValue ?? "",
      "subCategory": selectedSubCategoryValue ?? "",
      "careerLevel": selectedCareerLevel ?? "Junior",
      "experienceYears": expYears,
      "type": jobTypeText,
      "requiredSkills": addedSkills.map((s) {
        var temp = s;
        while (temp.endsWith(',') || temp.endsWith(' ')) {
          temp = temp.substring(0, temp.length - 1).trim();
        }
        return temp;
      }).join(", "),
      "description": descController.text.trim(),
      "requirements": reqController.text.trim(),
      "cvCount": int.parse(cvCountCtrl.text), 
      "codingCount": int.parse(codingCtrl.text),
      "behavioralCount": int.parse(behavioralCtrl.text),
      "technicalCount": int.parse(technicalCtrl.text),
      "startedAt": selectedStartDate!.toUtc().toIso8601String(),
      "endedAt": selectedEndDate!.toUtc().toIso8601String(),
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

  // Edit part
   
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
    descController.text = job.description ?? '';
    reqController.text = job.requirements ?? '';
    selectedCareerLevel = job.careerLevel;

    if (job.experienceYears != null) {
      expController.text = job.experienceYears.toString();
    }

    selectedCategoryValue = job.category;
    selectedSubCategoryValue = job.subCategory;
    
    if (selectedCategoryValue != null && selectedCategoryValue!.isNotEmpty) {
      try {
        final catMatch = jobCategories.firstWhere(
          (cat) => cat['value'] == selectedCategoryValue,
          orElse: () => {"label": selectedCategoryValue!, "value": selectedCategoryValue!}, 
        );
        selectedCategoryLabel = catMatch['label'];

        if (selectedSubCategoryValue != null && jobSubCategories.containsKey(selectedCategoryValue)) {
          final subMatch = jobSubCategories[selectedCategoryValue]!.firstWhere(
            (sub) => sub['value'] == selectedSubCategoryValue,
            orElse: () => {"label": selectedSubCategoryValue!, "value": selectedSubCategoryValue!},
          );
          selectedSubCategoryLabel = subMatch['label'];
        } else {
          selectedSubCategoryLabel = selectedSubCategoryValue; 
        }
      } catch (e) {
        print('Category Mapping Error in Edit: $e');
      }
    }

    try {
      if (job.startedAt != null && job.startedAt!.isNotEmpty) {
        selectedStartDate = DateTime.parse(job.startedAt!);
      }
      if (job.endedAt != null && job.endedAt!.isNotEmpty) {
        selectedEndDate = DateTime.parse(job.endedAt!);
      }
    } catch (e) {
      print('Date Parsing Error in Edit: $e');
    }

    cvCountCtrl.text = (job.cvCount ?? 0).toString();
    codingCtrl.text = (job.codingCount ?? 0).toString();
    behavioralCtrl.text = (job.behavioralCount ?? 0).toString();
    technicalCtrl.text = (job.technicalCount ?? 0).toString();

    addedSkills = (job.requiredSkills ?? []).map((s) {
      var temp = s.trim();
      while (temp.endsWith(',') || temp.endsWith(' ')) {
        temp = temp.substring(0, temp.length - 1).trim();
      }
      return '$temp,';
    }).toList();

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

  @override
  Future<void> close() {
    titleController.dispose();
    skillController.dispose();
    descController.dispose();
    reqController.dispose();
    expController.dispose();
    cvCountCtrl.dispose();
    codingCtrl.dispose();
    behavioralCtrl.dispose();
    technicalCtrl.dispose();
    return super.close();
  }
}