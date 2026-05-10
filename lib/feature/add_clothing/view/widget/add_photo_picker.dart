import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AddPhotoPicker extends StatelessWidget {
  const AddPhotoPicker({
    super.key,
    required this.imagePath,
    required this.onCameraTap,
    required this.onGalleryTap,
  });

  final String? imagePath;
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Container(
        height: AppSizes.maxiL,
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: AppRadius.allM,
          border: Border.all(color: AppColors.border),
        ),
        child: imagePath != null
            ? _SelectedImage(path: imagePath!)
            : const _EmptyState(),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.m),
        ),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSizes.xs),
            Container(
              width: AppSizes.xl,
              height: AppSizes.xxs,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.allXXL,
              ),
            ),
            const SizedBox(height: AppSizes.m),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.textSecondary,
              ),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onCameraTap();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.textSecondary,
              ),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGalleryTap();
              },
            ),
            const SizedBox(height: AppSizes.m),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.camera_alt_outlined,
          size: AppSizes.xl,
          color: AppColors.textHint,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          LocaleKeys.addItemPhotoPrompt.tr(),
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.s),
        const _AutoClassifyBadge(),
      ],
    );
  }
}

class _AutoClassifyBadge extends StatelessWidget {
  const _AutoClassifyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.horizontalS + AppPaddings.verticalXXS,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.allS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: AppSizes.s,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSizes.xxs),
          Text(
            LocaleKeys.addItemAutoClassify.tr(),
            style: AppTextStyles.badgeDark,
          ),
        ],
      ),
    );
  }
}

class _SelectedImage extends StatelessWidget {
  const _SelectedImage({required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: AppRadius.allM,
          child: Image.file(File(path), fit: BoxFit.cover),
        ),
        Positioned(
          top: AppSizes.xs,
          right: AppSizes.xs,
          child: Container(
            padding: AppPaddings.allXXS,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: AppSizes.s,
              color: AppColors.textOnDark,
            ),
          ),
        ),
      ],
    );
  }
}
