import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AuthLogoHeader extends StatelessWidget {
  const AuthLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys.appName.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.logoTitle,
        ),
        const SizedBox(height: AppSizes.xxs),
        Text(
          LocaleKeys.appTagline.tr().toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.labelTag,
        ),
      ],
    );
  }
}
