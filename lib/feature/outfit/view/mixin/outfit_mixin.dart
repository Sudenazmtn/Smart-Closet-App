import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/home/provider/weather_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';

mixin OutfitMixin<T extends StatefulWidget> on State<T> {
  final inputController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initChat());
  }

  @override
  void dispose() {
    inputController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _initChat() {
    if (!mounted) return;
    context
        .read<OutfitProvider>()
        .initChat(LocaleKeys.outfitAiGreeting.tr());
  }

  Future<void> onSend() async {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    inputController.clear();

    final weather = context.read<WeatherProvider>().weather;

    await context.read<OutfitProvider>().sendMessage(
          userText: text,
          aiErrorText: LocaleKeys.outfitAiError.tr(),
          temperature: weather?.temperature.toDouble(),
          weatherDescription: weather?.description,
        );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
