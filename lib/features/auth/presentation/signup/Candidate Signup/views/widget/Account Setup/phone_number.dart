import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_cubit.dart';
import 'package:intelli_hire/features/auth/controller/candidate%20register%20cubit/candidate_register_state.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_button.dart';
import 'package:intelli_hire/features/auth/presentation/signup/Candidate%20Signup/views/widget/shared/custom_text_field.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    final cubit = context.read<CandidateRegisterCubit>();
    if (cubit.savedPhone != null) {
      _phoneController.text = cubit.savedPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextField(
                  hint: "Phone Number",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone Number is required";
                    }
                    if (value.length < 10 || value.length > 15) {
                      return 'Invalid phone number length';
                    }
                    return null;
                  },
                  controller: _phoneController,
                ),
                const SizedBox(height: 48),

                BlocConsumer<CandidateRegisterCubit, CandidateRegisterState>(
                  listener: (context, state) {
                    if (state is CandidateRegisterSuccess) {
                      widget.onPressed();
                    } else if (state is CandidateRegisterFailure) {
                      if (state.isStep1Error) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMsg),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      onPressed: state is CandidateRegisterLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<CandidateRegisterCubit>()
                                    .registerCandidate(_phoneController.text);
                              }
                            },
                      title: state is CandidateRegisterLoading
                          ? "Registering..."
                          : "Next",
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
