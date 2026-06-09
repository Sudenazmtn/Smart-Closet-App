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
  String _selectedSubCategory = '';
  List<String> _selectedSeasons = [];
  String _selectedColor = '';
  String? _imagePath;

  String get selectedCategory => _selectedCategory;
  String get selectedSubCategory => _selectedSubCategory;
  List<String> get selectedSeasons => _selectedSeasons;
  String get selectedColor => _selectedColor;
  String? get imagePath => _imagePath;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void onCategorySelected(String value) {
    setState(() {
      _selectedCategory = value;
      _selectedSubCategory = '';
    });
  }

  void onSubCategorySelected(String value) =>
      setState(() => _selectedSubCategory = value);

  void onSeasonSelected(String value) {
    setState(() {
      if (_selectedSeasons.contains(value)) {
        _selectedSeasons.remove(value);
      } else {
        _selectedSeasons.add(value);
      }
    });
  }

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
      _selectedSeasons.isNotEmpty &&
      _selectedColor.isNotEmpty;

  Future<void> onSave(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (!_isFormValid) return;
    await context.read<ClothingProvider>().addClothing(
          name: nameController.text.trim(),
          category: _selectedCategory,
          subCategory: _selectedSubCategory.isEmpty ? null : _selectedSubCategory,
          color: _selectedColor,
          seasons: _selectedSeasons,
          imagePath: _imagePath,
        );
    if (context.mounted) context.pop();
  }
}
