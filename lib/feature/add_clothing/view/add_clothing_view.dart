import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/add_clothing/view/mixin/add_clothing_mixin.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_chip_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_multi_chip_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_subcategory_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_color_selector.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_photo_picker.dart';
import 'package:smart_closet_app/feature/add_clothing/view/widget/add_section_label.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/clothing_provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

part 'add_clothing_filter_data.dart';

class AddClothingView extends StatefulWidget {
  const AddClothingView({super.key});

  @override
  State<AddClothingView> createState() => _AddClothingViewState();
}

class _AddClothingViewState extends State<AddClothingView>
    with AddClothingMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      appBar: _AddClothingAppBar(onSave: () => onSave(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.allM,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.xs),
                AddPhotoPicker(
                  imagePath: imagePath,
                  onCameraTap: pickFromCamera,
                  onGalleryTap: pickFromGallery,
                ),
                const SizedBox(height: AppSizes.l),
                AddSectionLabel(LocaleKeys.addItemFieldName.tr()),
                const SizedBox(height: AppSizes.xs),
                _NameField(controller: nameController),
                const SizedBox(height: AppSizes.m),
                AddSectionLabel(LocaleKeys.addItemFieldCategory.tr()),
                const SizedBox(height: AppSizes.xs),
                AddChipSelector(
                  options: _kCategories
                      .map((o) => (value: o.value, label: o.localeKey.tr()))
                      .toList(),
                  selectedValue: selectedCategory,
                  onSelected: onCategorySelected,
                ),
                const SizedBox(height: AppSizes.m),
                if (_kSubCategories.containsKey(selectedCategory)) ...[
                  AddSectionLabel(LocaleKeys.addItemFieldSubCategory.tr()),
                  const SizedBox(height: AppSizes.xs),
                  AddSubcategorySelector(
                    options: _kSubCategories[selectedCategory]!
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
                  options: _kSeasons
                      .map((o) => (value: o.value, label: o.localeKey.tr()))
                      .toList(),
                  selectedValues: selectedSeasons,
                  onSelected: onSeasonSelected,
                ),
                const SizedBox(height: AppSizes.m),
                AddSectionLabel(LocaleKeys.addItemFieldColor.tr()),
                const SizedBox(height: AppSizes.xs),
                AddColorSelector(
                  options: _kColors
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
                _AddToWardrobeButton(onPressed: () => onSave(context)),
                const SizedBox(height: AppSizes.m),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddClothingAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _AddClothingAppBar({required this.onSave});
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
        LocaleKeys.addItemTitle.tr(),
        style: AppTextStyles.headingSmall,
      ),
      centerTitle: true,
      actions: [
        Consumer<ClothingProvider>(
          builder: (context, clothing, _) => TextButton(
            onPressed: clothing.isLoading ? null : onSave,
            child: Text(
              LocaleKeys.addItemSave.tr(),
              style: AppTextStyles.buttonLink,
            ),
          ),
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
          borderSide:
              const BorderSide(color: AppColors.accent, width: 1.5),
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

class _AddToWardrobeButton extends StatelessWidget {
  const _AddToWardrobeButton({required this.onPressed});
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
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.allS,
            ),
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
                  LocaleKeys.addItemTitle.tr(),
                  style: AppTextStyles.buttonAccent,
                ),
        ),
      ),
    );
  }
}
