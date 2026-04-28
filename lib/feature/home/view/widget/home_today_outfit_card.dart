import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class HomeTodaysOutfitCard extends StatelessWidget {
  const HomeTodaysOutfitCard({super.key, this.isLoading = false});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.homeSectionOutfit.tr(),
          style: AppTextStyles.headingSmall,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isLoading ? const _LoadingState() : const _OutfitContent(),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(color: AppColors.accent),
      ),
    );
  }
}

class _OutfitContent extends StatelessWidget {
  const _OutfitContent();

  // TODO: Provider'dan gerçek outfit gelecek
  static const List<String> _emojis = ['🧥', '👔', '👖'];
  static const String _description = 'Chic casual look for a cool day.';
  static const int _matchPercent = 92;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _emojis
                    .map((e) => Text(e, style: const TextStyle(fontSize: 52)))
                    .toList(),
              ),
            ),
            _MatchBadge(percent: _matchPercent),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _description,
          style: const TextStyle(
            fontFamily: 'DMSans',
            fontSize: 13,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$percent%',
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Text(
            'match',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 10,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
