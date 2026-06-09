import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/data/model/outfit_model.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';
import 'package:smart_closet_app/product/utils/extension/clothing_category_ext.dart';

/// Shows a modal bottom sheet with full outfit details.
Future<void> showOutfitDetail(BuildContext context, OutfitModel outfit) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _OutfitDetailSheet(outfit: outfit),
  );
}

class _OutfitDetailSheet extends StatefulWidget {
  const _OutfitDetailSheet({required this.outfit});
  final OutfitModel outfit;

  @override
  State<_OutfitDetailSheet> createState() => _OutfitDetailSheetState();
}

class _OutfitDetailSheetState extends State<_OutfitDetailSheet> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.outfit.isFavorite;
  }

  String get _eventLabel => widget.outfit.localizedEventLabel;
  String get _eventEmoji => widget.outfit.eventEmoji;
  String get _dateStr => widget.outfit.formattedDate;

  Future<void> _toggleFavorite() async {
    setState(() => _isFavorite = !_isFavorite);
    await context.read<OutfitProvider>().toggleFavorite(widget.outfit.id);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allM),
        title: Text(
          LocaleKeys.statsOutfitDetailDelete.tr(),
          style: AppTextStyles.headingSmall,
        ),
        content: Text(
          LocaleKeys.statsOutfitDetailDeleteConfirm.tr(),
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

    if (confirmed == true && mounted) {
      await context.read<OutfitProvider>().deleteOutfit(widget.outfit.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.outfit.itemsData ?? [];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: AppRadius.topL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          const SizedBox(height: AppSizes.s),
          Center(
            child: Container(
              width: AppSizes.xxl,
              height: AppSizes.xxxs,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.allXXXS,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.m),

          Flexible(
            child: SingleChildScrollView(
              padding: AppPaddings.horizontalM,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Container(
                        width: AppSizes.maxiS,
                        height: AppSizes.maxiS,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundCard,
                          borderRadius: AppRadius.allS,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Center(
                          child: Text(
                            _eventEmoji,
                            style: const TextStyle(fontSize: AppSizes.l),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSizes.s),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.outfit.name ?? _eventLabel,
                              style: AppTextStyles.headingSmall,
                            ),
                            Text(_dateStr, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      // Favorite toggle
                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: AppPaddings.allXXS,
                          decoration: BoxDecoration(
                            color: _isFavorite
                                ? Colors.red.withValues(alpha: 0.1)
                                : AppColors.backgroundCard,
                            borderRadius: AppRadius.allXS,
                            border: Border.all(
                              color: _isFavorite
                                  ? Colors.red
                                  : AppColors.border,
                            ),
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _isFavorite
                                ? Colors.red
                                : AppColors.textMuted,
                            size: AppSizes.m,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (widget.outfit.aiNote != null &&
                      widget.outfit.aiNote!.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.m),
                    Container(
                      padding: AppPaddings.allS,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCard,
                        borderRadius: AppRadius.allS,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: AppSizes.s,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: AppSizes.xxs),
                          Expanded(
                            child: Text(
                              widget.outfit.aiNote!,
                              style: AppTextStyles.bodyAiNote,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.m),
                  Text(
                    LocaleKeys.statsOutfitDetailItems.tr(),
                    style: AppTextStyles.headingSmall,
                  ),
                  const SizedBox(height: AppSizes.xs),

                  if (items.isEmpty)
                    Text(
                      '${widget.outfit.items.length} parça',
                      style: AppTextStyles.bodySmall,
                    )
                  else
                    ...items.map((item) => _ItemRow(item: item)),
                  const SizedBox(height: AppSizes.l),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _delete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: AppSizes.m,
                        color: AppColors.error,
                      ),
                      label: Text(
                        LocaleKeys.statsOutfitDetailDelete.tr(),
                        style: AppTextStyles.buttonDestructive,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.errorLight,
                          width: 0.8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allS,
                        ),
                        padding: AppPaddings.verticalS,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.m),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final ClothingModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.xs),
      padding: AppPaddings.allS,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.allS,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(borderRadius: AppRadius.allXXS, child: _thumb()),
          const SizedBox(width: AppSizes.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTextStyles.headingSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xxxs),
                Row(
                  children: [
                    _ColorDot(color: item.categoryColor, label: item.color),
                    const SizedBox(width: AppSizes.xs),
                    _Chip(label: item.subCategory ?? item.category),
                  ],
                ),
                if (item.wearCount > 0) ...[
                  const SizedBox(height: AppSizes.xxxs),
                  Text(
                    LocaleKeys.statsOutfitDetailWorn.tr(
                      args: ['${item.wearCount}'],
                    ),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _thumb() {
    const size = AppSizes.maxiS + AppSizes.xs;
    if (item.imageUrl != null) {
      return Image.network(
        '${ApiService.baseUrl}${item.imageUrl}',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _emojiBox(size),
      );
    }
    return _emojiBox(size);
  }

  Widget _emojiBox(double size) {
    return Container(
      width: size,
      height: size,
      color: item.categoryColor,
      child: Center(
        child: Text(
          item.categoryEmoji,
          style: const TextStyle(fontSize: AppSizes.l),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSizes.xs,
          height: AppSizes.xs,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
        ),
        const SizedBox(width: AppSizes.xxxs),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.xxs + AppSizes.xxxs,
        vertical: AppSizes.xxxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: AppRadius.allXXS,
      ),
      child: Text(label, style: AppTextStyles.bodySmall),
    );
  }
}
