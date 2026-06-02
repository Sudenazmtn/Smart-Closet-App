import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class WardrobeFilterItem {
  const WardrobeFilterItem({required this.label, required this.value});

  final String label;
  final String value;
}

class WardrobeFilterRow extends StatelessWidget {
  const WardrobeFilterRow({
    super.key,
    required this.filters,
    required this.selectedValue,
    required this.onFilterTap,
  });

  final List<WardrobeFilterItem> filters;
  final String selectedValue;
  final void Function(String) onFilterTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.xl + AppSizes.xxs,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSizes.l),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xs),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isActive = selectedValue == filter.value;

          return _FilterChip(
            filter: filter,
            isActive: isActive,
            onTap: () => onFilterTap(filter.value),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.isActive,
    required this.onTap,
  });

  final WardrobeFilterItem filter;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.s + AppSizes.xxs, vertical: AppSizes.xxs + AppSizes.xxxs),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: AppRadius.allXXL,
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Text(
          filter.label,
          style: isActive
              ? AppTextStyles.labelMediumActive.copyWith(color: AppColors.textOnDark)
              : AppTextStyles.labelMedium,
        ),
      ),
    );
  }
}
