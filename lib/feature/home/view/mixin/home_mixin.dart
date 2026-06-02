import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/home/provider/weather_provider.dart';

import '../../../wardrobe/provider/clothing_provider.dart';

mixin HomeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    await Future.wait([
      context.read<ClothingProvider>().loadClothes(),
      _fetchWeather(),
    ]);
  }

  Future<void> _fetchWeather() async {
    if (!mounted) return;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );

      if (!mounted) return;

      await context.read<WeatherProvider>().fetchWeather(
        lat: position.latitude,
        lon: position.longitude,
      );
    } catch (_) {
      if (!mounted) return;
      await context.read<WeatherProvider>().fetchWeather(
        lat: 41.0082,
        lon: 28.9784,
      );
    }
  }

  String greeting(String morning, String afternoon, String evening) {
    final hour = DateTime.now().hour;
    if (hour < 12) return morning;
    if (hour < 17) return afternoon;
    return evening;
  }
}
