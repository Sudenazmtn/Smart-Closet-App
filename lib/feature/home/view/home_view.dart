import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/feature/auth/provider/auth_provider.dart';
import 'package:smart_closet_app/feature/home/provider/weather_provider.dart';
import 'package:smart_closet_app/feature/home/view/mixin/home_mixin.dart';
import 'package:smart_closet_app/feature/home/view/widget/header.dart';
import 'package:smart_closet_app/feature/home/view/widget/home_today_outfit_card.dart';
import 'package:smart_closet_app/feature/home/view/widget/home_wardrobe_category.dart';
import 'package:smart_closet_app/feature/home/view/widget/home_weather_pill.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

part 'home_view_categories.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with HomeMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildWeather(),
                    const SizedBox(height: 16),

                    // ── Gardırop kategorileri ──────────────────────────────
                    Text(LocaleKeys.homeSectionWardrobe.tr(), style: AppTextStyles.headingSmall),
                    const SizedBox(height: 12),
                    Consumer<ClothingProvider>(
                      builder: (context, clothing, _) => HomeWardrobeCategories(
                        categories: buildCategories(clothing),
                        onCategoryTap: (_) => context.go(AppRoutes.wardrobe),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Stats + Hızlı aksiyonlar ───────────────────────────
                    _buildStatsBar(),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 24),

                    // ── Bugünkü kombin ─────────────────────────────────────
                    Consumer<ClothingProvider>(
                      builder: (context, clothing, _) =>
                          HomeTodaysOutfitCard(isLoading: clothing.isLoading),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const AppBottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final user = context.watch<AuthProvider>().currentUser;
    final displayName = user?.displayName ?? 'there';
    return HomeHeader(
      greeting: greeting(
        LocaleKeys.homeGoodMorning.tr(),
        LocaleKeys.homeGoodAfternoon.tr(),
        LocaleKeys.homeGoodEvening.tr(),
      ),
      displayName: displayName,
    );
  }

  Widget _buildWeather() {
    return Consumer<WeatherProvider>(
      builder: (context, weather, _) {
        if (weather.isLoading) return const HomeWeatherPillLoading();
        final w = weather.weather;
        if (w == null || !w.isValid) return const SizedBox.shrink();
        return HomeWeatherPill(weather: w);
      },
    );
  }

  Widget _buildStatsBar() {
    return Consumer<ClothingProvider>(
      builder: (context, clothing, _) {
        if (clothing.totalItems == 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatChip(icon: Icons.checkroom_outlined,    label: '${clothing.totalItems}',    sub: 'parça'),
              _Divider(),
              _StatChip(icon: Icons.star_outline_rounded,  label: '${clothing.favoriteCount}', sub: 'favori'),
              _Divider(),
              _StatChip(icon: Icons.loop_rounded,          label: '${clothing.neverWornCount}',sub: 'giyilmedi'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.auto_awesome_rounded,
            label: LocaleKeys.homeQuickAi.tr(),
            color: AppColors.accent,
            textColor: AppColors.primary,
            onTap: () => context.go(AppRoutes.outfit),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.add_rounded,
            label: LocaleKeys.homeQuickAdd.tr(),
            color: AppColors.backgroundCard,
            textColor: AppColors.primary,
            onTap: () => context.push(AppRoutes.addClothing),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.label, required this.sub});
  final IconData icon;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontFamily: 'DMSans', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textOnDark)),
        Text(sub, style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: AppColors.textOnDark.withValues(alpha: 0.6))),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.textOnDark.withValues(alpha: 0.15));
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w600, color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
