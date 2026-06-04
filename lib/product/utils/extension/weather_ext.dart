import 'package:smart_closet_app/product/data/model/weather_model.dart';

extension WeatherEmojiExtension on WeatherModel {
  String get weatherEmoji {
    final desc = description.toLowerCase();
    if (desc.contains('rain') || desc.contains('drizzle')) return '🌧️';
    if (desc.contains('snow')) return '❄️';
    if (desc.contains('thunderstorm')) return '⛈️';
    if (desc.contains('cloud')) return '⛅';
    if (desc.contains('mist') || desc.contains('fog')) return '🌫️';
    return '☀️';
  }

  String get temperatureLabel => '$temperature°C';

  String get cityTemperatureLabel =>
      city.isNotEmpty ? '$city, $temperature°C' : '$temperature°C';
}
