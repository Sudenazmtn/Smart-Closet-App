import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/feature/auth/provider/auth_provider.dart';
import 'package:smart_closet_app/feature/home/provider/weather_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/data/services/notification_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

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
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSizes.l,
                        AppSizes.l,
                        AppSizes.l,
                        AppSizes.m,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: AppSizes.maxiS + AppSizes.xxs,
                            height: AppSizes.maxiS + AppSizes.xxs,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
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
                                style: AppTextStyles.headingSmall,
                              ),
                              Text(email, style: AppTextStyles.bodySmall),
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
                            onTap: () => _showNotificationsSheet(context),
                          ),
                          _MenuItem(
                            icon: Icons.location_on_outlined,
                            iconBg: AppColors.iconBgGreen,
                            label: LocaleKeys.profileMenuLocation.tr(),
                            subtitle: locationSubtitle,
                            onTap: () {},
                          ),
                          _MenuItem(
                            icon: Icons.language_outlined,
                            iconBg: AppColors.iconBgBlue,
                            label: LocaleKeys.profileMenuLanguage.tr(),
                            subtitle: context.locale.languageCode == 'tr'
                                ? LocaleKeys.profileMenuLanguageTr.tr()
                                : LocaleKeys.profileMenuLanguageEn.tr(),
                            onTap: () => _showLanguageSheet(context),
                          ),
                          _MenuItem(
                            icon: Icons.lock_outline,
                            iconBg: AppColors.iconBgPurple,
                            label: LocaleKeys.profileMenuPrivacy.tr(),
                            subtitle: LocaleKeys.profileMenuPrivacySub.tr(),
                            onTap: () => _showPrivacySheet(context),
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

  Future<void> _showNotificationsSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _NotificationsSheet(),
    );
  }

  Future<void> _showPrivacySheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PrivacySheet(),
    );
  }

  Future<void> _showLanguageSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _LanguageSheet(),
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
          borderRadius: AppRadius.topL,
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
                    borderRadius: AppRadius.allXXXS,
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
    final auth = context.read<AuthProvider>();
    await auth.updateDisplayName(newName);
    if (mounted && auth.errorMessage == null) {
      Navigator.of(context).pop();
    }
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.topL,
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
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
                borderRadius: AppRadius.allXXXS,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.profileLanguageSheetTitle.tr(),
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.profileLanguageSheetSubtitle.tr(),
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 20),
          _LanguageOption(
            flag: '🇹🇷',
            label: LocaleKeys.profileMenuLanguageTr.tr(),
            isSelected: currentLocale.languageCode == 'tr',
            onTap: () async {
              await context.setLocale(const Locale('tr'));
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 12),
          _LanguageOption(
            flag: '🇬🇧',
            label: LocaleKeys.profileMenuLanguageEn.tr(),
            isSelected: currentLocale.languageCode == 'en',
            onTap: () async {
              await context.setLocale(const Locale('en'));
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _PrivacySheet extends StatelessWidget {
  const _PrivacySheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.topL,
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
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
                borderRadius: AppRadius.allXXXS,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.profilePrivacySheetTitle.tr(),
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: AppRadius.allS,
              border: Border.all(color: AppColors.border, width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    LocaleKeys.profilePrivacyDataNote.tr(),
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _confirmDelete(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.errorLight.withValues(alpha: 0.3),
                borderRadius: AppRadius.allS,
                border: Border.all(color: AppColors.errorLight, width: 0.8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.profilePrivacyDeleteAccount.tr(),
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        Text(
                          LocaleKeys.profilePrivacyDeleteAccountSub.tr(),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.error,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allM),
        title: Text(
          LocaleKeys.profilePrivacyDeleteConfirmTitle.tr(),
          style: AppTextStyles.headingSmall,
        ),
        content: Text(
          LocaleKeys.profilePrivacyDeleteConfirmBody.tr(),
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              LocaleKeys.profilePrivacyDeleteCancel.tr(),
              style: AppTextStyles.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              LocaleKeys.profilePrivacyDeleteConfirmBtn.tr(),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final auth = context.read<AuthProvider>();
      Navigator.of(context).pop();
      await auth.signOut();
    }
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String flag;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.accentLight,
          borderRadius: AppRadius.allS,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: AppSizes.l)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.headingSmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsSheet extends StatefulWidget {
  const _NotificationsSheet();

  @override
  State<_NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<_NotificationsSheet> {
  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 8, minute: 0);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await NotificationService.loadPrefs();
    if (mounted) {
      setState(() {
        _enabled = prefs.enabled;
        _time = prefs.time;
        _loading = false;
      });
    }
  }

  Future<void> _onToggle(bool value) async {
    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.profileNotifPermissionDenied.tr()),
            ),
          );
        }
        return;
      }
      await NotificationService.scheduleDailyReminder(
        hour: _time.hour,
        minute: _time.minute,
        title: LocaleKeys.profileNotifReminderTitle.tr(),
        body: LocaleKeys.profileNotifReminderBody.tr(),
      );
      if (mounted) {
        setState(() => _enabled = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.profileNotifSaved.tr())),
        );
      }
    } else {
      await NotificationService.cancelDailyReminder();
      if (mounted) {
        setState(() => _enabled = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.profileNotifCancelled.tr())),
        );
      }
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null || !mounted) return;
    setState(() => _time = picked);
    if (_enabled) {
      await NotificationService.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
        title: LocaleKeys.profileNotifReminderTitle.tr(),
        body: LocaleKeys.profileNotifReminderBody.tr(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.profileNotifSaved.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.topL,
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
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
                borderRadius: AppRadius.allXXXS,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            LocaleKeys.profileNotifSheetTitle.tr(),
            style: AppTextStyles.headingSmall,
          ),
          const SizedBox(height: 20),
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentLight,
                borderRadius: AppRadius.allS,
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.profileNotifDailyToggle.tr(),
                          style: AppTextStyles.headingSmall,
                        ),
                        Text(
                          LocaleKeys.profileNotifDailyToggleSub.tr(),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _enabled,
                    onChanged: _onToggle,
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
            if (_enabled) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: AppRadius.allS,
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          LocaleKeys.profileNotifTimeLabel.tr(),
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Text(
                        _time.format(context),
                        style: AppTextStyles.headingSmall,
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.border,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
