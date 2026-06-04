import 'package:easy_localization/easy_localization.dart';

class WeatherModel {
  const WeatherModel({
    required this.city,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.outfitTip,
    required this.windSpeed,
    required this.humidity,
  });

  final String city;
  final int temperature;
  final int feelsLike;
  final String description;
  final String iconCode;
  final String outfitTip;
  final int windSpeed;
  final int humidity;

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final temp      = (json['temperature'] as num?)?.round() ?? 0;
    final feelsLike = (json['feels_like']  as num?)?.round() ?? 0;
    final windSpeed = (json['wind_speed']  as num?)?.round() ?? 0;
    final humidity  = (json['humidity']    as num?)?.round() ?? 0;

    final rawTip = (json['outfit_tip'] as String?) ?? '';
    final outfitTip = rawTip.startsWith('weather_tip_') ? rawTip.tr() : rawTip;

    return WeatherModel(
      city:        (json['city']        as String?) ?? '',
      temperature: temp,
      feelsLike:   feelsLike,
      description: (json['description'] as String?) ?? '',
      iconCode:    (json['icon_code']   as String?) ?? '',
      outfitTip:   outfitTip,
      windSpeed:   windSpeed,
      humidity:    humidity,
    );
  }

  bool get isValid => temperature != 0 || description.isNotEmpty;
}
