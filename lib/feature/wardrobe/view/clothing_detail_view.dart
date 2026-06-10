import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_chip_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_color_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_multi_chip_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_section_label.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_subcategory_selector.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/feature/wardrobe/view/mixin/clothing_detail_mixin.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/constant/clothing_form_options.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

class ClothingDetailView extends StatefulWidget {
  const ClothingDetailView({super.key, required this.item});

  final ClothingModel item;

  @override
  State<ClothingDetailView> createState() => _ClothingDetailViewState();
}

class _ClothingDetailViewState extends State<ClothingDetailView>
    with ClothingDetailMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      appBar: _DetailAppBar(onSave: () => onSave(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.allM,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.xs),
                _ItemPhoto(item: item),
                const SizedBox(height: AppSizes.xs),
                _WearInfo(item: item),
                const SizedBox(height: AppSizes.l),
                AddSectionLabel(LocaleKeys.addItemFieldName.tr()),
                const SizedBox(height: AppSizes.xs),
                _NameField(controller: nameController),
                const SizedBox(height: AppSizes.m),
                AddSectionLabel(LocaleKeys.addItemFieldCategory.tr()),
                const SizedBox(height: AppSizes.xs),
                AddChipSelector(
                  options: kClothingCategories
                      .map((o) => (value: o.value, label: o.localeKey.tr()))
                      .toList(),
                  selectedValue: selectedCategory,
                  onSelected: onCategorySelected,
                ),
                const SizedBox(height: AppSizes.m),
                if (kClothingSubCategories.containsKey(selectedCategory)) ...[
                  AddSectionLabel(LocaleKeys.addItemFieldSubCategory.tr()),
                  const SizedBox(height: AppSizes.xs),
                  AddSubcategorySelector(
                    options: kClothingSubCategories[selectedCategory]!
                        .map((o) => (value: o.value, label: o.localeKey.tr()))
                        .toList(),
                    selectedValue: selectedSubCategory,
                    onSelected: onSubCategorySelected,
                  ),
                  const SizedBox(height: AppSizes.m),
                ],
                AddSectionLabel(LocaleKeys.addItemFieldSeason.tr()),
                const SizedBox(height: AppSizes.xs),
                AddMultiChipSelector(
                  options: kClothingSeasons
                      .map((o) => (value: o.value, label: o.localeKey.tr()))
                      .toList(),
                  selectedValues: selectedSeasons,
                  onSelected: onSeasonSelected,
                ),
                const SizedBox(height: AppSizes.m),
                AddSectionLabel(LocaleKeys.addItemFieldColor.tr()),
                const SizedBox(height: AppSizes.xs),
                AddColorSelector(
                  options: kClothingColors
                      .map((o) => (
                            value: o.value,
                            label: o.localeKey.tr(),
                            swatch: o.swatch,
                          ))
                      .toList(),
                  selectedValue: selectedColor,
                  onSelected: onColorSelected,
                ),
                const SizedBox(height: AppSizes.xl),
                _SaveButton(onPressed: () => onSave(context)),
                const SizedBox(height: AppSizes.s),
                _DeleteButton(onPressed: () => onDelete(context)),
                const SizedBox(height: AppSizes.m),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DetailAppBar({required this.onSave});
  final VoidCallback onSave;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.accentLight,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: AppSizes.m,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        LocaleKeys.itemDetailTitle.tr(),
        style: AppTextStyles.headingSmall,
      ),
      centerTitle: true,
      actions: [
        Consumer<ClothingProvider>(
          builder: (context, clothing, _) => TextButton(
            onPressed: clothing.isLoading ? null : onSave,
            child: Text(
              LocaleKeys.commonSave.tr(),
              style: AppTextStyles.buttonLink,
            ),
          ),
        ),
      ],
    );
  }
}

class _ItemPhoto extends StatelessWidget {
  const _ItemPhoto({required this.item});
  final ClothingModel item;

  static const double _height = 180;

  @override
  Widget build(BuildContext context) {
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: AppRadius.allM,
        child: Image.network(
          '${ApiService.baseUrl}${item.imageUrl}',
          height: _height,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _EmojiBox(item: item),
        ),
      );
    }
    return _EmojiBox(item: item);
  }
}

class _EmojiBox extends StatelessWidget {
  const _EmojiBox({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _ItemPhoto._height,
      decoration: BoxDecoration(
        color: item.categoryColor,
        borderRadius: AppRadius.allM,
      ),
      child: Center(
        child: Text(
          item.categoryEmoji,
          style: const TextStyle(fontSize: AppSizes.emojiL),
        ),
      ),
    );
  }
}

class _WearInfo extends StatelessWidget {
  const _WearInfo({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.checkroom_outlined,
          size: AppSizes.s,
          color: AppColors.textMuted,
        ),
        const SizedBox(width: AppSizes.xxs),
        Text(
          item.wearCount > 0
              ? LocaleKeys.statsWornTimes.tr(args: ['${item.wearCount}'])
              : LocaleKeys.itemDetailNeverWorn.tr(),
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: AppTextStyles.inputText,
      decoration: InputDecoration(
        hintText: LocaleKeys.fieldHintItemName.tr(),
        hintStyle: AppTextStyles.inputHint,
        filled: true,
        fillColor: AppColors.backgroundCard,
        border: OutlineInputBorder(
          borderRadius: AppRadius.allS,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.allS,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.allS,
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: AppPaddings.allS,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return LocaleKeys.validationRequired
              .tr(args: [LocaleKeys.addItemFieldName.tr()]);
        }
        return null;
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClothingProvider>(
      builder: (context, clothing, _) => SizedBox(
        height: AppSizes.maxiS,
        child: ElevatedButton(
          onPressed: clothing.isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnAccent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allS),
          ),
          child: clothing.isLoading
              ? const SizedBox(
                  width: AppSizes.m,
                  height: AppSizes.m,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textOnAccent,
                  ),
                )
              : Text(
                  LocaleKeys.itemDetailSave.tr(),
                  style: AppTextStyles.buttonAccent,
                ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClothingProvider>(
      builder: (context, clothing, _) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: clothing.isLoading ? null : onPressed,
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: AppSizes.m,
            color: AppColors.error,
          ),
          label: Text(
            LocaleKeys.itemDetailDelete.tr(),
            style: AppTextStyles.buttonDestructive,
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.errorLight, width: 0.8),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allS),
            padding: AppPaddings.verticalS,
          ),
        ),
      ),
    );
  }
}
