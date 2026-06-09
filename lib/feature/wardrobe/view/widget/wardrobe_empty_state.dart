import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_emojis.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class WardrobeEmptyState extends StatelessWidget {
  const WardrobeEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppEmojis.tops, style: TextStyle(fontSize: AppSizes.emojiXXXL)),
          const SizedBox(height: 12),
          Text(
            LocaleKeys.wardrobeEmptyTitle.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.wardrobeEmptySubtitle.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class WardrobeErrorState extends StatelessWidget {
  const WardrobeErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(AppEmojis.warning, style: TextStyle(fontSize: AppSizes.emojiXXL)),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onRetry,
            child: Text(
              LocaleKeys.commonRetry.tr(),
              style: AppTextStyles.buttonLink,
            ),
          ),
        ],
      ),
    );
  }
}
