import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.displayName,
    this.weatherStatus,
  });

  final String greeting;
  final String displayName;
  final String? weatherStatus;

  String get _initial =>
      displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$greeting ',
                      style: AppTextStyles.homeGreetingText,
                    ),
                    TextSpan(
                      text: displayName,
                      style: AppTextStyles.homeGreetingName,
                    ),
                  ],
                ),
              ),
              if (weatherStatus != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    weatherStatus!,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
            ],
          ),
        ),
        _Avatar(initial: _initial),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.xxl,
      height: AppSizes.xxl,
      decoration: const BoxDecoration(
        color: AppColors.accent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(initial, style: AppTextStyles.homeAvatarInitial),
      ),
    );
  }
}
