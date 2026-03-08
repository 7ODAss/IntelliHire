import 'package:flutter/material.dart';
import 'package:intelli_hire/core/utils/app_color.dart';
import 'package:intelli_hire/core/utils/app_text_style.dart';

class CustomDropdownMenu extends StatefulWidget {
  const CustomDropdownMenu({
    super.key,
    required this.title,
    required this.items,
    required this.hint,
    this.value,
    this.onChanged,
  });

  final String title;
  final List<String> items;
  final String hint;
  final String? value;
  final void Function(String?)? onChanged;

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: AppTextStyle.textstyle14.copyWith(color: AppColor.darkBlue),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return MenuAnchor(
              alignmentOffset: const Offset(0, 4),

              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(0),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColor.primary, width: 1.5),
                  ),
                ),
              ),

              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: controller.isOpen
                            ? AppColor.primary
                            : const Color(0xffD6D6D6),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.value ?? widget.hint,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyle.textstyle14.copyWith(
                              color: widget.value == null
                                  ? const Color(0xffD6D6D6)
                                  : AppColor.darkBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: controller.isOpen
                              ? AppColor.primary
                              : const Color(0xffD6D6D6),
                        ),
                      ],
                    ),
                  ),
                );
              },

              menuChildren: widget.items.map((String label) {
                final bool isSelected = widget.value == label;

                return MenuItemButton(
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      Size(constraints.maxWidth, 45),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (isSelected) {
                        return const Color(0xffB9c2fd).withValues(alpha: 0.25);
                      }
                      if (states.contains(WidgetState.hovered) ||
                          states.contains(WidgetState.focused)) {
                        return const Color(0xffB9c2fd).withValues(alpha: 0.15);
                      }
                      return Colors.transparent;
                    }),
                  ),
                  onPressed: () {
                    if (widget.onChanged != null) {
                      widget.onChanged!(label);
                    }
                  },
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth - 32,
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.textstyle14.copyWith(
                        color: AppColor.darkBlue,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
