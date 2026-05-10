import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';

mixin AddClothingMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final _picker = ImagePicker();

  String _selectedCategory = '';
  String _selectedSeason = '';
  String _selectedColor = '';
  String? _imagePath;

  String get selectedCategory => _selectedCategory;
  String get selectedSeason => _selectedSeason;
  String get selectedColor => _selectedColor;
  String? get imagePath => _imagePath;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void onCategorySelected(String value) =>
      setState(() => _selectedCategory = value);

  void onSeasonSelected(String value) =>
      setState(() => _selectedSeason = value);

  void onColorSelected(String value) =>
      setState(() => _selectedColor = value);

  Future<void> pickFromCamera() => _pick(ImageSource.camera);
  Future<void> pickFromGallery() => _pick(ImageSource.gallery);

  Future<void> _pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file != null) setState(() => _imagePath = file.path);
  }

  bool get _isFormValid =>
      _selectedCategory.isNotEmpty &&
      _selectedSeason.isNotEmpty &&
      _selectedColor.isNotEmpty;

  Future<void> onSave(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (!_isFormValid) return;
    await context.read<ClothingProvider>().addClothing(
          name: nameController.text.trim(),
          category: _selectedCategory,
          color: _selectedColor,
          season: _selectedSeason,
          imagePath: _imagePath,
        );
    if (context.mounted) context.pop();
  }
}
