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
    return WeatherModel(
      city: json['city'] as String,
      temperature: json['temperature'] as int,
      feelsLike: json['feels_like'] as int,
      description: json['description'] as String,
      iconCode: json['icon_code'] as String,
      outfitTip: json['outfit_tip'] as String,
      windSpeed: json['wind_speed'] as int,
      humidity: json['humidity'] as int,
    );
  }
}
