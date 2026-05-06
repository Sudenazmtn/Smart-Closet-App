import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';

mixin StatsMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStats());
  }

  Future<void> _loadStats() async {
    if (!mounted) return;
    await context.read<OutfitProvider>().loadStats();
  }

  Future<void> onRetry() async {
    if (!mounted) return;
    await context.read<OutfitProvider>().loadStats();
  }
}
