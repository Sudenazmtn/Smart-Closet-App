import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';

/// Filtre chip verisi
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
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Text(
          filter.label,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
