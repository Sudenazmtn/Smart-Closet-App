import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

import '../../../feature/auth/provider/auth_provider.dart';

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
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.profileTitle.tr(),
                                style: const TextStyle(
                                  fontFamily: 'PlayfairDisplay',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const Icon(
                                Icons.settings_outlined,
                                color: Colors.white54,
                                size: 22,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontFamily: 'PlayfairDisplay',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontFamily: 'DMSans',
                                      fontSize: 12,
                                      color: Colors.white54,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.edit_outlined,
                            iconBg: const Color(0xFFF5F0E8),
                            label: LocaleKeys.profileMenuEditProfile.tr(),
                            subtitle: LocaleKeys.profileMenuEditProfileSub.tr(),
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.notifications_outlined,
                            iconBg: const Color(0xFFFEE2E2),
                            label: LocaleKeys.profileMenuNotifications.tr(),
                            subtitle: LocaleKeys.profileMenuNotificationsSub
                                .tr(),
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.language_outlined,
                            iconBg: const Color(0xFFD1FAE5),
                            label: LocaleKeys.profileMenuLocation.tr(),
                            subtitle: 'Istanbul, Turkey',
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline,
                            iconBg: const Color(0xFFEDE9FE),
                            label: LocaleKeys.profileMenuPrivacy.tr(),
                            subtitle: LocaleKeys.profileMenuPrivacySub.tr(),
                            onTap: () {},
                          ),

                          const SizedBox(height: 16),

                          // Sign Out butonu
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => _onSignOut(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFFCA5A5),
                                  width: 0.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                LocaleKeys.authSignOut.tr(),
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFA32D2D),
                                ),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 12),
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
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
