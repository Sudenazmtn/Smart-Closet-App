import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/view/clothing_detail_view.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/enums/clothing_status_enum.dart';

mixin ClothingDetailMixin on State<ClothingDetailView> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;

  late String _selectedCategory;
  late String _selectedSubCategory;
  late final List<String> _selectedSeasons;
  late String _selectedColor;

  ClothingModel get item => widget.item;
  String get selectedCategory => _selectedCategory;
  String get selectedSubCategory => _selectedSubCategory;
  List<String> get selectedSeasons => _selectedSeasons;
  String get selectedColor => _selectedColor;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: item.name);
    _selectedCategory = item.category;
    _selectedSubCategory = item.subCategory ?? '';
    _selectedSeasons = List.of(item.seasonsList);
    _selectedColor = item.color;
  }

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

  void onColorSelected(String value) => setState(() => _selectedColor = value);

  bool get _isFormValid =>
      _selectedCategory.isNotEmpty &&
      _selectedSeasons.isNotEmpty &&
      _selectedColor.isNotEmpty;

  Future<void> onSave(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    if (!_isFormValid) return;

    final provider = context.read<ClothingProvider>();
    await provider.updateClothing(
      item.id,
      name: nameController.text.trim(),
      category: _selectedCategory,
      subCategory: _selectedSubCategory.isEmpty ? null : _selectedSubCategory,
      color: _selectedColor,
      season: _selectedSeasons.join(','),
    );

    if (!context.mounted) return;
    if (provider.status == ClothingStatus.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LocaleKeys.itemDetailUpdated.tr())),
      );
      context.pop();
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  Future<void> onDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allM),
        title: Text(
          LocaleKeys.commonDeleteConfirmTitle.tr(),
          style: AppTextStyles.headingSmall,
        ),
        content: Text(
          LocaleKeys.commonDeleteConfirmMessage.tr(),
          style: AppTextStyles.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              LocaleKeys.commonCancel.tr(),
              style: AppTextStyles.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              LocaleKeys.commonDelete.tr(),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final provider = context.read<ClothingProvider>();
    await provider.deleteClothing(item.id);

    if (!context.mounted) return;
    if (provider.status == ClothingStatus.success) {
      context.pop();
    } else if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }
}
