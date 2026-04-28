import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Font Families ─────────────────────────────────────────────────────────
  static const String _serif = 'PlayfairDisplay';
  static const String _sans = 'DMSans';

  // =========================================================================
  // DISPLAY — Playfair Display (serif)
  // Kullanım: splash title, ekran başlıkları, logo
  // =========================================================================

  /// "Dress with intention." — splash büyük başlık
  static final TextStyle displayLarge = TextStyle(
    fontFamily: _serif,
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  /// "SmartCloset" — logo / header başlığı
  static const TextStyle displayMedium = TextStyle(
    fontFamily: _serif,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// "My Wardrobe", "Statistics" — sayfa başlıkları
  static const TextStyle displaySmall = TextStyle(
    fontFamily: _serif,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// italic varyant — "intention." gibi vurgulu kelimeler
  static const TextStyle displayItalic = TextStyle(
    fontFamily: _serif,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: AppColors.accent,
    height: 1.2,
  );

  // =========================================================================
  // HEADING — DM Sans
  // Kullanım: kart başlıkları, section title'lar
  // =========================================================================

  /// "Good morning, Sude" — home greeting
  static const TextStyle headingLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// "Welcome back", "Create account" — auth card başlıkları
  static const TextStyle headingMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// "Today's Outfit", "My Wardrobe" — section başlıkları
  static const TextStyle headingSmall = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Koyu bg üzerinde beyaz heading — profile header, AI ekranı
  static const TextStyle headingOnDark = TextStyle(
    fontFamily: _sans,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.3,
  );

  // =========================================================================
  // BODY — DM Sans
  // Kullanım: açıklamalar, AI notu, genel metin
  // =========================================================================

  /// Ana body metni
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  /// İkincil body — subtitle, açıklama
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Küçük body — muted açıklama, meta
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.5,
  );

  /// AI notu — "Claude says:" açıklaması
  static const TextStyle bodyAiNote = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );

  // =========================================================================
  // LABEL — DM Sans
  // Kullanım: form label, chip, badge, nav item
  // =========================================================================

  /// Form field label — "Email", "Password"
  static const TextStyle labelLarge = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Chip / filter label — "Tops", "Casual"
  static const TextStyle labelMedium = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    height: 1.4,
  );

  /// Aktif chip label
  static const TextStyle labelMediumActive = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.accentDark,
    height: 1.4,
  );

  /// Section üst etiket — "SMART WARDROBE AI" uppercase tag
  static const TextStyle labelTag = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    letterSpacing: 1.2,
    height: 1.4,
  );

  /// Stat sayısı — "38", "12", "94"
  static const TextStyle statNumber = TextStyle(
    fontFamily: _sans,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    height: 1.2,
  );

  /// Stat label — "Items", "Outfits"
  static const TextStyle statLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // =========================================================================
  // BUTTON — DM Sans
  // =========================================================================

  /// Primary buton — "Get Started", "Sign In", "Add to Wardrobe"
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    letterSpacing: 0.3,
    height: 1.2,
  );

  /// Accent buton — "Create Account", "Save Outfit"
  static const TextStyle buttonAccent = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnAccent,
    letterSpacing: 0.3,
    height: 1.2,
  );

  /// Secondary buton / link — "Already have an account?"
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  /// Link text — "Sign in", "Forgot password?"
  static const TextStyle buttonLink = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    height: 1.4,
  );

  /// Destructive — "Sign Out"
  static const TextStyle buttonDestructive = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
    height: 1.4,
  );

  // =========================================================================
  // INPUT — DM Sans
  // =========================================================================

  /// Input içindeki yazı
  static const TextStyle inputText = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Input placeholder
  static const TextStyle inputHint = TextStyle(
    fontFamily: _sans,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.5,
  );

  // =========================================================================
  // BADGE & PILL
  // =========================================================================

  /// "%92 match" badge
  static const TextStyle badge = TextStyle(
    fontFamily: _sans,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: AppColors.matchBadgeText,
    height: 1.2,
  );

  /// "Auto-classify" dark badge
  static const TextStyle badgeDark = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // =========================================================================
  // WEATHER PILL
  // =========================================================================

  /// "Istanbul, 18°C"
  static const TextStyle weatherCity = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// "Light jacket recommended."
  static const TextStyle weatherDesc = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // =========================================================================
  // GREETING
  // =========================================================================

  /// "Good morning,"
  static const TextStyle greetingLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  /// "Sude" — kullanıcı adı
  static const TextStyle greetingName = TextStyle(
    fontFamily: _serif,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );
}
