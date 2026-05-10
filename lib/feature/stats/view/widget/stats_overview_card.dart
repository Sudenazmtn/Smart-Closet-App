import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class StatsOverviewCard extends StatelessWidget {
  const StatsOverviewCard({
    super.key,
    required this.totalItems,
    required this.totalOutfits,
    required this.neverWornCount,
    required this.itemsLabel,
    required this.outfitsLabel,
    required this.neverWornLabel,
  });

  final int totalItems;
  final int totalOutfits;
  final int neverWornCount;
  final String itemsLabel;
  final String outfitsLabel;
  final String neverWornLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPaddings.allM,
      padding: AppPaddings.allM,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.allM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: totalItems, label: itemsLabel),
          _Divider(),
          _StatItem(value: totalOutfits, label: outfitsLabel),
          _Divider(),
          _StatItem(value: neverWornCount, label: neverWornLabel),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value', style: AppTextStyles.statNumber),
        const SizedBox(height: AppSizes.xxs),
        Text(label, style: AppTextStyles.statLabel),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: AppSizes.xl,
      color: AppColors.primaryMid,
    );
  }
}
