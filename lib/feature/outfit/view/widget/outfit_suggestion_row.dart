import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_clothing_card.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/data/model/clothing_model.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class OutfitSuggestionRow extends StatefulWidget {
  const OutfitSuggestionRow({
    super.key,
    required this.items,
    this.allOutfits,
    this.eventType,
    this.styleTip,
    this.destinationCity,
  });

  final List<ClothingModel> items;
  final List<List<ClothingModel>>? allOutfits;
  final String? eventType;
  final String? styleTip;
  final String? destinationCity;

  @override
  State<OutfitSuggestionRow> createState() => _OutfitSuggestionRowState();
}

class _OutfitSuggestionRowState extends State<OutfitSuggestionRow> {
  int _currentIndex = 0;
  bool _saving = false;
  bool _saved = false;

  List<List<ClothingModel>> get _outfits {
    if (widget.allOutfits != null && widget.allOutfits!.isNotEmpty) {
      return widget.allOutfits!;
    }
    return widget.items.isNotEmpty ? [widget.items] : [];
  }

  List<ClothingModel> get _currentItems =>
      _outfits.isEmpty ? [] : _outfits[_currentIndex];

  bool get _hasMultiple => _outfits.length > 1;

  String _generateOutfitName(String? eventType) {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final months = [
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    final month = months[now.month - 1];
    const labels = {
      'casual': 'Günlük Kombin',
      'formal': 'Resmi Kombin',
      'date': 'Randevu Kombini',
      'business': 'İş Kombini',
      'sport': 'Spor Kombini',
      'party': 'Parti Kombini',
    };
    final base = labels[eventType] ?? 'Özel Kombin';
    return '$base • $day $month';
  }

  // Reset saved badge when user switches to a different alternative
  void _switchTo(int index) {
    setState(() {
      _currentIndex = index;
      _saved = false;
    });
  }

  Future<void> _saveOutfit(BuildContext context) async {
    if (_saving || _saved || _currentItems.isEmpty) return;
    setState(() => _saving = true);

    final itemIds = _currentItems.map((i) => i.id).toList();

    await context.read<OutfitProvider>().saveOutfit(
      itemIds: itemIds,
      itemsData: _currentItems,
      eventType: widget.eventType,
      aiNote: widget.styleTip,
      name: _generateOutfitName(widget.eventType),
    );

    if (mounted)
      setState(() {
        _saving = false;
        _saved = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.destinationCity != null) ...[
          _DestinationPill(city: widget.destinationCity!),
          const SizedBox(height: AppSizes.xxs),
        ],
        if (_hasMultiple) ...[
          Row(
            children: [
              _NavButton(
                icon: Icons.chevron_left_rounded,
                enabled: _currentIndex > 0,
                onTap: () => _switchTo(_currentIndex - 1),
              ),
              const SizedBox(width: AppSizes.xxs),
              Text(
                LocaleKeys.statsOutfitAlternatives.tr(
                  args: ['${_currentIndex + 1}', '${_outfits.length}'],
                ),
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(width: AppSizes.xxs),
              _NavButton(
                icon: Icons.chevron_right_rounded,
                enabled: _currentIndex < _outfits.length - 1,
                onTap: () => _switchTo(_currentIndex + 1),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  _outfits.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: AppSizes.xxxs),
                    width: i == _currentIndex ? AppSizes.s : AppSizes.xxs,
                    height: AppSizes.xxs,
                    decoration: BoxDecoration(
                      color: i == _currentIndex
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: AppRadius.allXXXS,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.xxs),
        ],

        // Outfit items
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: SizedBox(
            key: ValueKey(_currentIndex),
            height: AppSizes.maxiM + AppSizes.l,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _currentItems.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSizes.xs),
              itemBuilder: (_, i) => OutfitClothingCard(item: _currentItems[i]),
            ),
          ),
        ),

        if (widget.styleTip != null && widget.styleTip!.isNotEmpty) ...[
          const SizedBox(height: AppSizes.xxs),
          Text('💡 ${widget.styleTip}', style: AppTextStyles.bodySmall),
        ],

        // Save button
        const SizedBox(height: AppSizes.xs),
        _SaveButton(
          saving: _saving,
          saved: _saved,
          onTap: () => _saveOutfit(context),
        ),
      ],
    );
  }
}

// ─── Save button ──────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.saving,
    required this.saved,
    required this.onTap,
  });

  final bool saving;
  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.m,
          vertical: AppSizes.xxs + AppSizes.xxxs,
        ),
        decoration: BoxDecoration(
          color: saved
              ? AppColors.success.withValues(alpha: 0.12)
              : AppColors.primary.withValues(alpha: 0.08),
          borderRadius: AppRadius.allS,
          border: Border.all(
            color: saved ? AppColors.success : AppColors.primary,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (saving)
              const SizedBox(
                width: AppSizes.s,
                height: AppSizes.s,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.primary,
                ),
              )
            else
              Icon(
                saved
                    ? Icons.check_circle_outline_rounded
                    : Icons.bookmark_add_outlined,
                size: AppSizes.s,
                color: saved ? AppColors.success : AppColors.primary,
              ),
            const SizedBox(width: AppSizes.xxs),
            Text(
              saved
                  ? LocaleKeys.statsOutfitSaved.tr()
                  : LocaleKeys.statsSaveOutfit.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: saved ? AppColors.success : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Nav button ───────────────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: AppPaddings.allXXS,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.border,
          borderRadius: AppRadius.allXXS,
        ),
        child: Icon(
          icon,
          size: AppSizes.m,
          color: enabled ? AppColors.textOnDark : AppColors.textMuted,
        ),
      ),
    );
  }
}

// ─── Destination pill ─────────────────────────────────────────────────────────

class _DestinationPill extends StatelessWidget {
  const _DestinationPill({required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s,
        vertical: AppSizes.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentLight,
        borderRadius: AppRadius.allS,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: AppSizes.s,
            color: AppColors.accentDark,
          ),
          const SizedBox(width: AppSizes.xxs),
          Text(
            city,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accentDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
