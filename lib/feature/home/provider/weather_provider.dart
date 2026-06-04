import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/weather_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/utils/enums/weather_enum.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherStatus _status = WeatherStatus.idle;
  WeatherModel? _weather;
  String? _errorMessage;

  WeatherStatus get status => _status;
  WeatherModel? get weather => _weather;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasData => _weather != null;

  Future<void> fetchWeather({required double lat, required double lon}) async {
    _setLoading();
    try {
      final response = await ApiService.instance.dio.get(
        '/weather/',
        queryParameters: {'lat': lat.toString(), 'lon': lon.toString()},
      );
      _weather = WeatherModel.fromJson(response.data as Map<String, dynamic>);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setLoading() {
    _status = WeatherStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = WeatherStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = WeatherStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
