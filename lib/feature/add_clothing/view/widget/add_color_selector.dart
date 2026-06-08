import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AddColorSelector extends StatelessWidget {
  const AddColorSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final List<({String value, String label, Color swatch})> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.m,
      runSpacing: AppSizes.m,
      children: options.map((opt) {
        final isActive = opt.value == selectedValue;
        return GestureDetector(
          onTap: () => onSelected(opt.value),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: AppSizes.xl,
                height: AppSizes.xl,
                decoration: BoxDecoration(
                  color: opt.swatch,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isActive ? AppColors.accent : AppColors.border,
                    width: isActive ? 2.5 : 1,
                  ),
                ),
                child: isActive
                    ? Icon(
                        Icons.check_rounded,
                        size: AppSizes.m,
                        color:
                            opt.value == 'white' || opt.value == 'beige' || opt.value == 'yellow'
                                ? AppColors.textSecondary
                                : AppColors.white,
                      )
                    : null,
              ),
              const SizedBox(height: AppSizes.xxs),
              Text(opt.label, style: AppTextStyles.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }
}
