import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AddSubcategorySelector extends StatelessWidget {
  const AddSubcategorySelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<({String value, String label})> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: options.map((opt) {
          final isActive = opt.value == selectedValue;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.xs),
            child: GestureDetector(
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
            ),
          );
        }).toList(),
      ),
    );
  }
}
