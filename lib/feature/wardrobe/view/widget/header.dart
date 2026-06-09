import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class WardrobeHeader extends StatelessWidget {
  const WardrobeHeader({
    super.key,
    required this.itemCount,
    required this.onAddTap,
  });

  final int itemCount;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPaddings.screenHTop,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.wardrobeTitle.tr(),
                  style: AppTextStyles.wardrobeTitle,
                ),
                const SizedBox(height: AppSizes.xxxs),
                Text(
                  LocaleKeys.wardrobeItemCount.tr(args: [itemCount.toString()]),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: AppSizes.buttonSize,
              height: AppSizes.buttonSize,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.textOnDark,
                size: AppSizes.l,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
