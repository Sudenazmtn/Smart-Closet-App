import 'package:smart_closet_app/product/data/model/weather_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_emojis.dart';

extension WeatherEmojiExtension on WeatherModel {
  String get weatherEmoji {
    final desc = description.toLowerCase();
    if (desc.contains('rain') || desc.contains('drizzle')) return AppEmojis.weatherRain;
    if (desc.contains('snow'))                             return AppEmojis.weatherSnow;
    if (desc.contains('thunderstorm'))                     return AppEmojis.weatherThunderstorm;
    if (desc.contains('cloud'))                            return AppEmojis.weatherCloudy;
    if (desc.contains('mist') || desc.contains('fog'))     return AppEmojis.weatherFog;
    return AppEmojis.weatherSunny;
  }

  String get temperatureLabel => '$temperature°C';

  String get cityTemperatureLabel =>
      city.isNotEmpty ? '$city, $temperature°C' : '$temperature°C';
}
