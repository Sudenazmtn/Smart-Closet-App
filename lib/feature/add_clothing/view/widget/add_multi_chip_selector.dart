import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AddMultiChipSelector extends StatelessWidget {
  const AddMultiChipSelector({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.onSelected,
  });

  final List<({String value, String label})> options;
  final List<String> selectedValues;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.xs,
      runSpacing: AppSizes.xs,
      children: options.map((opt) {
        final isActive = selectedValues.contains(opt.value);
        return GestureDetector(
          onTap: () => onSelected(opt.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.s,
              vertical: AppSizes.xxs + AppSizes.xxxs,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.accent
                  : AppColors.backgroundCard,
              borderRadius: AppRadius.allS,
              border: Border.all(
                color: isActive ? AppColors.accent : AppColors.border,
              ),
            ),
            child: Text(
              opt.label,
              style: isActive
                  ? AppTextStyles.labelMediumActive
                  : AppTextStyles.labelMedium,
            ),
          ),
        );
      }).toList(),
    );
  }
}
