import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

import '../../../feature/auth/provider/auth_provider.dart';
import '../../../feature/wardrobe/provider/clothing_provider.dart';
import '../../../feature/wardrobe/provider/outfit_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final displayName = user?.displayName ?? 'User';
    final email = user?.email ?? '';
    final initial = displayName[0].toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Header ───────────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      color: AppColors.primary,
                      padding: EdgeInsets.fromLTRB(AppSizes.l, AppSizes.m, AppSizes.l, AppSizes.xl),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.profileTitle.tr(),
                                style: AppTextStyles.displaySmall.copyWith(
                                  color: AppColors.textOnDark,
                                ),
                              ),
                              Icon(
                                Icons.settings_outlined,
                                color: AppColors.textOnDark.withValues(alpha: 0.6),
                                size: AppSizes.m + AppSizes.xs - AppSizes.xxs,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSizes.m),
                          Row(
                            children: [
                              Container(
                                width: AppSizes.maxiS + AppSizes.xxs,
                                height: AppSizes.maxiS + AppSizes.xxs,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initial,
                                    style: AppTextStyles.headingOnDark,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSizes.s + AppSizes.xxs),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: AppTextStyles.headingOnDark,
                                  ),
                                  Text(
                                    email,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textOnDark.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ── Menü ─────────────────────────────────────────────────
                    Padding(
                      padding: AppPaddings.allL,
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.edit_outlined,
                            iconBg: AppColors.iconBgOrange,
                            label: LocaleKeys.profileMenuEditProfile.tr(),
                            subtitle: LocaleKeys.profileMenuEditProfileSub.tr(),
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.notifications_outlined,
                            iconBg: AppColors.iconBgRed,
                            label: LocaleKeys.profileMenuNotifications.tr(),
                            subtitle: LocaleKeys.profileMenuNotificationsSub
                                .tr(),
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.language_outlined,
                            iconBg: AppColors.iconBgGreen,
                            label: LocaleKeys.profileMenuLocation.tr(),
                            subtitle: 'Istanbul, Turkey',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline,
                            iconBg: AppColors.iconBgPurple,
                            label: LocaleKeys.profileMenuPrivacy.tr(),
                            subtitle: LocaleKeys.profileMenuPrivacySub.tr(),
                            onTap: () {},
                          ),

                          const SizedBox(height: AppSizes.m),

                          // Sign Out butonu
                          SizedBox(
                            width: double.infinity,
                            height: AppSizes.maxiS - AppSizes.xxs,
                            child: OutlinedButton(
                              onPressed: () => _onSignOut(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: AppColors.errorLight,
                                  width: 0.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.allS,
                                ),
                              ),
                              child: Text(
                                LocaleKeys.authSignOut.tr(),
                                style: AppTextStyles.buttonDestructive,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNavBar(currentIndex: 3),
          ],
        ),
      ),
    );
  }

  Future<void> _onSignOut(BuildContext context) async {
    // Tüm kullanıcıya özel state'i temizle
    context.read<ClothingProvider>().resetState();
    context.read<OutfitProvider>().resetState();

    final auth = context.read<AuthProvider>();
    await auth.signOut();
    if (context.mounted) {
      context.go(AppRoutes.onboarding);
    }
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppPaddings.verticalS,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.xl + AppSizes.xxs,
              height: AppSizes.xl + AppSizes.xxs,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: AppRadius.allS,
              ),
              child: Icon(icon, size: AppSizes.m + AppSizes.xxs, color: AppColors.textSecondary),
            ),
            const SizedBox(width: AppSizes.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.headingSmall),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.border,
              size: AppSizes.l,
            ),
          ],
        ),
      ),
    );
  }
}
