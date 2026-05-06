import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/feature/home/provider/weather_provider.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/feature/home/view/widget/header.dart';
import 'package:smart_closet_app/feature/home/view/widget/home_today_outfit_card.dart';
import 'package:smart_closet_app/feature/home/view/widget/home_wardrobe_category.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

import '../../../feature/auth/provider/auth_provider.dart';
import '../../../feature/wardrobe/provider/clothing_provider.dart';
import 'mixin/home_mixin.dart';
import 'widget/home_weather_pill.dart';

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

                    // ── Header ─────────────────────────────────────────────
                    // AuthProvider'dan kullanıcı adı — watch ile dinler
                    _buildHeader(),

                    const SizedBox(height: 16),

                    // ── Hava durumu ────────────────────────────────────────
                    // WeatherProvider — Consumer ile bağımsız rebuild
                    _buildWeather(),

                    const SizedBox(height: 28),

                    // ── Gardırop kategorileri ──────────────────────────────
                    // part of dosyasından gelen homeCategories listesi
                    Text(
                      LocaleKeys.homeSectionWardrobe.tr(),
                      style: AppTextStyles.headingSmall,
                    ),
                    const SizedBox(height: 12),
                    HomeWardrobeCategories(
                      categories: homeCategories,
                      onCategoryTap: (filter) {
                        context.go(AppRoutes.wardrobe);
                      },
                    ),

                    const SizedBox(height: 24),

                    // ── Today's Outfit ─────────────────────────────────────
                    // ClothingProvider — Consumer ile bağımsız rebuild
                    _buildTodaysOutfit(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Bottom nav ─────────────────────────────────────────────────
            const AppBottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  // context.watch → AuthProvider değişince sadece bu kısım rebuild olur

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

  // ── Hava durumu ───────────────────────────────────────────────────────────
  // Consumer → WeatherProvider değişince sadece bu blok rebuild olur

  Widget _buildWeather() {
    return Consumer<WeatherProvider>(
      builder: (context, weather, _) {
        if (weather.isLoading) return const HomeWeatherPillLoading();
        if (!weather.hasData) return const SizedBox.shrink();
        return HomeWeatherPill(weather: weather.weather!);
      },
    );
  }

  // ── Today's Outfit ────────────────────────────────────────────────────────
  // Consumer → ClothingProvider değişince sadece bu blok rebuild olur

  Widget _buildTodaysOutfit() {
    return Consumer<ClothingProvider>(
      builder: (context, clothing, _) =>
          HomeTodaysOutfitCard(isLoading: clothing.isLoading),
    );
  }
}
