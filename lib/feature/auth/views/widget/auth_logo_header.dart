import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
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
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 34,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1917),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          LocaleKeys.appTagline.tr().toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.labelTag,
        ),
      ],
    );
  }
}
