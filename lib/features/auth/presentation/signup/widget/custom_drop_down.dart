import 'package:flutter/material.dart';

import '../../../../../core/utils/app_text_style.dart';

class CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final String hintText;
  final String? Function(String?)? validator;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFD1D5DB), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF134CC7), width: 1.5),
        ),
      ),
      onChanged: (value) {},
      hint: Text('Industry', style: AppTextStyle.loginSubTitleStyle),
      items: items.map((industry) {
        return DropdownMenuItem(
          value: industry,
          child: Text(industry, style: AppTextStyle.signUpDropDownCompanyStyle),
        );
      }).toList(),
      icon: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Icon(
          Icons.keyboard_arrow_down,
          color: Color(0xFF6B7280),
          size: 24,
        ),
      ),
      isExpanded: true,
      dropdownColor: Colors.white,
      menuMaxHeight: 250,
      style: AppTextStyle.signUpDropDownCompanyStyle,
      borderRadius: BorderRadius.circular(20),
      validator: validator,
    );
  }
}
