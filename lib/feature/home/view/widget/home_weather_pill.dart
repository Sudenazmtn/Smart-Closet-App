import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/weather_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/weather_ext.dart';

class HomeWeatherPill extends StatelessWidget {
  const HomeWeatherPill({super.key, required this.weather});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.allM,
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allCard,
      ),
      child: Row(
        children: [
          Text(
            weather.weatherEmoji,
            style: const TextStyle(fontSize: AppSizes.emojiXS),
          ),
          const SizedBox(width: AppSizes.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weather.cityTemperatureLabel, style: AppTextStyles.weatherCity),
                const SizedBox(height: AppSizes.xxxs),
                Text(weather.outfitTip, style: AppTextStyles.weatherDesc),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeWeatherPillLoading extends StatelessWidget {
  const HomeWeatherPillLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allCard,
      ),
      child: Center(
        child: SizedBox(
          width: AppSizes.screenH,
          height: AppSizes.screenH,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
        ),
      ),
    );
  }
}
