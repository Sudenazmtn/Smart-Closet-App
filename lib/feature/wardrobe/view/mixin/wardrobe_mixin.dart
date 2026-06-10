import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/clothing_provider.dart';

mixin WardrobeMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  /// Loads clothes for the currently selected filter so the list always
  /// matches the highlighted filter chip (e.g. when arriving from a home
  /// category card or returning to the wardrobe).
  Future<void> _loadInitialData() async {
    if (!mounted) return;
    final provider = context.read<ClothingProvider>();
    await provider.changeFilter(provider.selectedFilter);
  }

  Future<void> onFilterChanged(String value) async {
    if (!mounted) return;
    await context.read<ClothingProvider>().changeFilter(value);
  }

  Future<void> onRetry() async {
    if (!mounted) return;
    final provider = context.read<ClothingProvider>();
    await provider.changeFilter(provider.selectedFilter);
  }

  Future<void> onDeleteItem(int id) async {
    if (!mounted) return;
    await context.read<ClothingProvider>().deleteClothing(id);
  }
}
