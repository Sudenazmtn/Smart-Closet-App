import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
import '../../../feature/home/provider/weather_provider.dart';
import '../../../feature/wardrobe/provider/clothing_provider.dart';
import '../../../feature/wardrobe/provider/outfit_provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureWeather());
  }

  Future<void> _ensureWeather() async {
    final wp = context.read<WeatherProvider>();
    if (wp.hasData) return;
    try {
      final svcEnabled = await Geolocator.isLocationServiceEnabled();
      if (!svcEnabled) {
        await _fetchFallback();
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied)
        perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        await _fetchFallback();
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      if (!mounted) return;
      await context.read<WeatherProvider>().fetchWeather(
        lat: pos.latitude,
        lon: pos.longitude,
      );
    } catch (_) {
      await _fetchFallback();
    }
  }

  Future<void> _fetchFallback() async {
    if (!mounted) return;
    await context.read<WeatherProvider>().fetchWeather(
      lat: 41.0082,
      lon: 28.9784,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final displayName = user?.displayName ?? 'User';
    final email = user?.email ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    final weatherProvider = context.watch<WeatherProvider>();
    final locationSubtitle =
        weatherProvider.hasData && weatherProvider.weather!.city.isNotEmpty
        ? weatherProvider.weather!.city
        : weatherProvider.isLoading
        ? '...'
        : '—';

    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.primary,
                      padding: EdgeInsets.fromLTRB(
                        AppSizes.l,
                        AppSizes.m,
                        AppSizes.l,
                        AppSizes.xl,
                      ),
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
                                color: AppColors.textOnDark.withValues(
                                  alpha: 0.6,
                                ),
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
                                      color: AppColors.textOnDark.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: AppPaddings.allL,
                      child: Column(
                        children: [
                          _MenuItem(
                            icon: Icons.edit_outlined,
                            iconBg: AppColors.iconBgOrange,
                            label: LocaleKeys.profileMenuEditProfile.tr(),
                            subtitle: LocaleKeys.profileMenuEditProfileSub.tr(),
                            onTap: () =>
                                _showEditProfileSheet(context, displayName),
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
                            subtitle: locationSubtitle,
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

  Future<void> _showEditProfileSheet(
    BuildContext context,
    String currentName,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(currentName: currentName),
    );
  }

  Future<void> _onSignOut(BuildContext context) async {
    context.read<ClothingProvider>().resetState();
    context.read<OutfitProvider>().resetState();

    final auth = context.read<AuthProvider>();
    await auth.signOut();
    if (context.mounted) {
      context.go(AppRoutes.onboarding);
    }
  }
}

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
              child: Icon(
                icon,
                size: AppSizes.m + AppSizes.xxs,
                color: AppColors.textSecondary,
              ),
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

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.currentName});
  final String currentName;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.profileEditSheetTitle.tr(),
                style: AppTextStyles.headingSmall,
              ),
              const SizedBox(height: 20),
              Text(
                LocaleKeys.profileEditNameLabel.tr(),
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: LocaleKeys.profileEditNameHint.tr(),
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.allS,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.allS,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.allS,
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? LocaleKeys.profileEditNameHint.tr()
                    : null,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allS,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        LocaleKeys.profileEditCancel.tr(),
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Consumer<AuthProvider>(
                      builder: (ctx, auth, _) => ElevatedButton(
                        onPressed: auth.isLoading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allS,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(LocaleKeys.profileEditSave.tr()),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final newName = _nameController.text.trim();
    await context.read<AuthProvider>().updateDisplayName(newName);
    if (mounted) Navigator.of(context).pop();
  }
}
