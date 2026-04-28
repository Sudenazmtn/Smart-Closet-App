import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/clothing_provider.dart';

/// WardrobeView'ın initState ve veri yükleme
/// sorumluluğunu taşır. View dosyasını temiz tutar.
mixin WardrobeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    await context.read<ClothingProvider>().loadClothes();
  }

  Future<void> onFilterChanged(String value) async {
    if (!mounted) return;
    await context.read<ClothingProvider>().changeFilter(value);
  }

  Future<void> onRetry() async {
    if (!mounted) return;
    await context.read<ClothingProvider>().loadClothes();
  }

  Future<void> onDeleteItem(int id) async {
    if (!mounted) return;
    await context.read<ClothingProvider>().deleteClothing(id);
  }
}
