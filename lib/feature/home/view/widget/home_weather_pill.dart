import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/weather_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/weather_ext.dart';

class HomeWeatherPill extends StatelessWidget {
  const HomeWeatherPill({super.key, required this.weather});

  final WeatherModel weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(weather.weatherEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weather.cityTemperatureLabel,
                  style: AppTextStyles.weatherCity,
                ),
                const SizedBox(height: 2),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}
