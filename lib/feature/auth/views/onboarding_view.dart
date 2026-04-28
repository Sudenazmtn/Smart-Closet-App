import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

import 'widget/clothing_tile.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  static const List<ClothingTileData> _items = [
    ClothingTileData(emoji: '👚', color: Color(0xFFF5C5C5)),
    ClothingTileData(emoji: '👗', color: Color(0xFFBDD8C0)),
    ClothingTileData(emoji: '👜', color: Color(0xFFB8CEDD)),
    ClothingTileData(emoji: '👖', color: Color(0xFFB8CEDD)),
    ClothingTileData(emoji: '👠', color: Color(0xFFF5C5C5)),
    ClothingTileData(emoji: '🧣', color: Color(0xFFBDD8C0)),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),

                  // Başlık
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Dress with\n',
                          style: const TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 42,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            height: 1.15,
                          ),
                        ),
                        TextSpan(
                          text: 'intention.',
                          style: const TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 42,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            color: AppColors.accent,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                    itemCount: _items.length,
                    itemBuilder: (context, index) =>
                        ClothingTile(data: _items[index]),
                  ),

                  const Spacer(),

                  // Get Started butonu
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.go(AppRoutes.register),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnDark,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        LocaleKeys.authGetStarted.tr(),
                        style: const TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Alt link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        LocaleKeys.authAlreadyHaveAccount.tr(),
                        style: AppTextStyles.buttonSecondary,
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          LocaleKeys.authSignIn.tr(),
                          style: const TextStyle(
                            fontFamily: 'DMSans',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
