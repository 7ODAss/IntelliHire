import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../controller/sign_up_cubit.dart';

// 1. The Main Reusable Widget (The Trigger)
class SharedBottomSheetSelector extends StatelessWidget {
  final String title;
  final String hintText;
  final String? selectedItem;
  final List<String> items;
  final ValueChanged<String> onSelected;
  final bool isEnabled;
  final String disabledMessage;

  const SharedBottomSheetSelector({
    super.key,
    required this.title,
    required this.hintText,
    required this.items,
    required this.onSelected,
    this.selectedItem,
    this.isEnabled = true,
    this.disabledMessage = 'Please select the previous option first',
  });

  void _showBottomSheet(BuildContext context) {
    if (!isEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(disabledMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _SelectionSheetContent(
          title: title,
          searchHint: hintText,
          items: items,
          selectedItem: selectedItem,
          onSelected: onSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedItem != null && selectedItem!.isNotEmpty;

    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hasSelection ? AppColor.signUpConditionColor2 : AppColor.hintColor,
            width: hasSelection ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasSelection ? selectedItem! : title, // Show title if no selection
                style: hasSelection
                    ? AppTextStyle.signUpDropDownCompanyStyle
                    : AppTextStyle.hintTextStyle,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_outlined,
              color: isEnabled ? AppColor.signUpConditionColor2 : AppColor.hintColor,
            ),
          ],
        ),
      ),
    );
  }
}

// 2. The Bottom Sheet Content (The Search & List)
class _SelectionSheetContent extends StatefulWidget {
  final String title;
  final String searchHint;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onSelected;

  const _SelectionSheetContent({
    required this.title,
    required this.searchHint,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  State<_SelectionSheetContent> createState() => _SelectionSheetContentState();
}

class _SelectionSheetContentState extends State<_SelectionSheetContent> {
  late List<String> _filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Container(
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: AppColor.hintColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8,),
          // Header (Title + Close Button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    widget.title,
                    style:  AppTextStyle.searchTitleStyle
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFF1F1F1),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.black),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16,),
          Divider(color: Color(0xFFD6D6D6),thickness: 1,),
          const SizedBox(height: 16,),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.signUpConditionColor2),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List Items
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
              child: Text(
                'No results found',
                style: AppTextStyle.hintTextStyle,
              ),
            )
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = widget.selectedItem == item;

                return InkWell(
                  onTap: () {
                    widget.onSelected(item);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isSelected ? AppColor.searchCardItemColor : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              item,
                              style: isSelected
                                  ? AppTextStyle.signUpDropDownCompanyStyle.copyWith(
                                color: AppColor.signUpConditionColor2,
                              )
                                  : AppTextStyle.signUpDropDownCompanyStyle
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. Usage Example (LocationSelectionSection)
// ==========================================

class LocationSelectionSection extends StatelessWidget {
  final SignUpCubit cubit;

  const LocationSelectionSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Country Selector ---
        Text('Country', style: AppTextStyle.fieldTitleStyle),
        const SizedBox(height: 8),

        SharedBottomSheetSelector(
          title: 'Select Country',
          hintText: 'Search...',
          items: cubit.countries,
          selectedItem: cubit.state.selectedCountry,
          onSelected: (value) {
            cubit.countryController.text = value;
            cubit.changeSelectedCountry(value);
            cubit.changeSelectedGovernorate('');
            cubit.govController.clear();
          },
        ),

        const SizedBox(height: 16),

        // --- Governorate Selector ---
        Text('Governorate', style: AppTextStyle.fieldTitleStyle),
        const SizedBox(height: 8),

        SharedBottomSheetSelector(
          title: 'Select Governorate',
          hintText: 'Search...',
          items: cubit.state.selectedCountry != null
              ? (cubit.countryGovernorates[cubit.state.selectedCountry!] ?? [])
              : [],
          selectedItem: cubit.state.selectedGovernorate, // Use state value directly
          isEnabled: cubit.state.selectedCountry != null,
          disabledMessage: 'Please select a country first',
          onSelected: (value) {
            cubit.govController.text = value;
            cubit.changeSelectedGovernorate(value);
          },
        ),
      ],
    );
  }
}