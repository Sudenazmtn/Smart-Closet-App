import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/repositories/clothing_repository.dart';
import 'package:smart_closet_app/product/utils/enums/clothing_status_enum.dart';

class ClothingProvider extends ChangeNotifier {
  ClothingProvider() : _repository = ClothingRepository();

  final ClothingRepository _repository;

  ClothingStatus _status = ClothingStatus.idle;
  List<ClothingModel> _items = [];
  String? _errorMessage;
  String _selectedFilter = 'all';

  // ── Getters ───────────────────────────────────────────────────────────────
  ClothingStatus get status => _status;
  List<ClothingModel> get items => _items;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == ClothingStatus.loading;
  String get selectedFilter => _selectedFilter;
  int get totalItems => _items.length;

  int get neverWornCount => _items.where((i) => i.wearCount == 0).length;

  List<ClothingModel> get mostWorn {
    final worn = _items.where((i) => i.wearCount > 0).toList();
    worn.sort((a, b) => b.wearCount.compareTo(a.wearCount));
    return worn.take(5).toList();
  }

  // ── Filter değiştir ───────────────────────────────────────────────────────
  Future<void> changeFilter(String filter) async {
    _selectedFilter = filter;
    notifyListeners();
    final category = filter == 'all' ? null : filter;
    await loadClothes(category: category);
  }

  // ── Tüm kıyafetleri yükle ─────────────────────────────────────────────────
  Future<void> loadClothes({
    String? category,
    String? season,
    String? color,
  }) async {
    _setLoading();
    try {
      _items = await _repository.getClothes(
        category: category,
        season: season,
        color: color,
      );
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Kıyafet ekle ──────────────────────────────────────────────────────────
  Future<void> addClothing({
    required String name,
    required String category,
    required String color,
    required String season,
    String? imagePath,
  }) async {
    _setLoading();
    try {
      final newItem = await _repository.addClothing(
        name: name,
        category: category,
        color: color,
        season: season,
        imagePath: imagePath,
      );
      _items.insert(0, newItem);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Kıyafet sil ───────────────────────────────────────────────────────────
  Future<void> deleteClothing(int id) async {
    _setLoading();
    try {
      await _repository.deleteClothing(id);
      _items.removeWhere((item) => item.id == id);
      _setSuccess();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Giyildi olarak işaretle ───────────────────────────────────────────────
  Future<void> markAsWorn(int id) async {
    try {
      final updated = await _repository.markAsWorn(id);
      final index = _items.indexWhere((item) => item.id == id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void resetStatus() {
    _status = ClothingStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  // ── Private helpers ───────────────────────────────────────────────────────
  void _setLoading() {
    _status = ClothingStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = ClothingStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = ClothingStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
