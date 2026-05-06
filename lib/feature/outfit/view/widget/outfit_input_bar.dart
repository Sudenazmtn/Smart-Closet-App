import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class OutfitInputBar extends StatelessWidget {
  const OutfitInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.allS,
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: AppSizes.l,
            height: AppSizes.l,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: AppSizes.m,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.inputText,
              decoration: InputDecoration(
                hintText: LocaleKeys.outfitAskPlaceholder.tr(),
                hintStyle: AppTextStyles.inputHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: AppPaddings.verticalXXS,
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          GestureDetector(
            onTap: isLoading ? null : onSend,
            child: Container(
              width: AppSizes.l,
              height: AppSizes.l,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: AppRadius.allS,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: AppSizes.s,
                      height: AppSizes.s,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.textOnAccent,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      size: AppSizes.m,
                      color: AppColors.textOnAccent,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
