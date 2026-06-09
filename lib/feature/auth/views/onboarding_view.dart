import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_emojis.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class _ClothingTileData {
  const _ClothingTileData({required this.emoji, required this.color});
  final String emoji;
  final Color color;
}

class _ClothingTile extends StatelessWidget {
  const _ClothingTile({required this.data});
  final _ClothingTileData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: AppRadius.allM,
      ),
      child: Center(
        child: Text(data.emoji, style: const TextStyle(fontSize: AppSizes.emojiL)),
      ),
    );
  }
}

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

  static const List<_ClothingTileData> _items = [
    _ClothingTileData(emoji: AppEmojis.tops,      color: Color(0xFFF5C5C5)),
    _ClothingTileData(emoji: AppEmojis.dress,     color: Color(0xFFBDD8C0)),
    _ClothingTileData(emoji: AppEmojis.bags,      color: Color(0xFFB8CEDD)),
    _ClothingTileData(emoji: AppEmojis.bottoms,   color: Color(0xFFB8CEDD)),
    _ClothingTileData(emoji: AppEmojis.shoes,     color: Color(0xFFF5C5C5)),
    _ClothingTileData(emoji: AppEmojis.scarf,     color: Color(0xFFBDD8C0)),
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

  Widget _buildGrid() {
    return Column(
      children: [
        Row(
          children: [0, 1, 2].map((i) => _buildCell(i)).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [3, 4, 5].map((i) => _buildCell(i)).toList(),
        ),
      ],
    );
  }

  Widget _buildCell(int index) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: index % 3 == 0 ? 0 : 5,
          right: index % 3 == 2 ? 0 : 5,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: _ClothingTile(data: _items[index]),
        ),
      ),
    );
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
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 48),

                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Dress with\n',
                                    style: AppTextStyles.displayHero.copyWith(
                                      color: AppColors.textPrimary,
                                      height: 1.15,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'intention.',
                                    style: AppTextStyles.displayHero.copyWith(
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

                            _buildGrid(),
                          ],
                        ),

                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () =>
                                    context.go(AppRoutes.register),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textOnDark,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.allS,
                                  ),
                                ),
                                child: Text(
                                  LocaleKeys.authGetStarted.tr(),
                                  style: AppTextStyles.buttonPrimary,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

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
                                    style: AppTextStyles.authLink,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
