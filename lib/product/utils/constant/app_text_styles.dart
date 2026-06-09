import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontSans  = 'DMSans';
  static const String fontSerif = 'PlayfairDisplay';

  // ignore: unused_field
  static const String _serif = fontSerif;
  // ignore: unused_field
  static const String _sans  = fontSans;

  static final TextStyle displayLarge = TextStyle(
    fontFamily: _serif,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: _serif,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: _serif,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle displayItalic = TextStyle(
    fontFamily: _serif,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: AppColors.accent,
    height: 1.2,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle headingOnDark = TextStyle(
    fontFamily: _sans,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  static const TextStyle bodyAiNote = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle labelMediumActive = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.accentDark,
    height: 1.4,
  );

  static const TextStyle labelTag = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    letterSpacing: 1.2,
    height: 1.4,
  );

  static const TextStyle statNumber = TextStyle(
    fontFamily: _sans,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  static const TextStyle statLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle buttonAccent = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnAccent,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle buttonLink = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    height: 1.4,
  );

  static const TextStyle buttonDestructive = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.4,
  );

  static const TextStyle inputText = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.5,
  );

  static const TextStyle badge = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.matchBadgeText,
    height: 1.2,
  );

  static const TextStyle badgeDark = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static const TextStyle weatherCity = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle weatherDesc = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle greetingLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle greetingName = TextStyle(
    fontFamily: _serif,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Auth
  static const TextStyle logoTitle = TextStyle(
    fontFamily: _serif,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle authLink = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle googleButtonText = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Onboarding
  static const TextStyle displayHero = TextStyle(
    fontFamily: _serif,
    fontSize: 42,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  // Home
  static const TextStyle homeGreetingText = TextStyle(
    fontFamily: _sans,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle homeGreetingName = TextStyle(
    fontFamily: _serif,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle homeAvatarInitial = TextStyle(
    fontFamily: _serif,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  static const TextStyle statChipValue = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  static const TextStyle matchBadgePercent = TextStyle(
    fontFamily: _sans,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  // Wardrobe
  static const TextStyle wardrobeTitle = TextStyle(
    fontFamily: _serif,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Nav
  static const TextStyle navLabelActive = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle navLabelInactive = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );
}
