import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AuthGoogleButton extends StatelessWidget {
  const AuthGoogleButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.maxiS,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border, width: 0.8),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allS),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.google,
              size: AppSizes.m + AppSizes.xxxs,
              color: AppColors.googleBlue,
            ),
            const SizedBox(width: AppSizes.xs),
            Text(
              LocaleKeys.authContinueWithGoogle.tr(),
              style: AppTextStyles.googleButtonText,
            ),
          ],
        ),
      ),
    );
  }
}
