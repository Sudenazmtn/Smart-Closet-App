import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1C1917); // espresso — butonlar, header
  static const Color primaryLight = Color(
    0xFF2C2825,
  ); // koyu kahve — dark kart bg
  static const Color primaryMid = Color(0xFF3C3530); // border dark modda

  static const Color accent = Color(
    0xFFD4B483,
  ); // muted gold — CTA, badge, aktif
  static const Color accentDark = Color(
    0xFF92703A,
  ); // koyu gold — aktif chip text
  static const Color accentLight = Color(
    0xFFF5F0E8,
  ); // krem — card bg, input bg

  static const Color background = Color(0xFFF7EAC8);
  static const Color backgroundSecondary = Color(0xFFF5F5F4); // input, chip bg
  static const Color backgroundCard = Color(0xFFFFFFFF); // beyaz kart

  static const Color surfaceCream = Color(
    0xFFF5F0E8,
  ); // krem — weather pill, stat bg
  static const Color surfaceBlue = Color(
    0xFFE8EFF5,
  ); // mavi tint — kıyafet kart
  static const Color surfaceGreen = Color(
    0xFFEDF0E8,
  ); // yeşil tint — kıyafet kart
  static const Color surfacePink = Color(
    0xFFF5E8EE,
  ); // pembe tint — kıyafet kart
  static const Color surfaceLavender = Color(
    0xFFF0EAF5,
  ); // lavanta tint — kıyafet kart
  static const Color surfaceAmber = Color(0xFFFEF3C7); // amber — goal/uyarı bg

  static const Color textPrimary = Color(0xFF1C1917); // ana metin
  static const Color textSecondary = Color(0xFF57534E); // ikincil metin
  static const Color textMuted = Color(
    0xFF78716C,
  ); // muted — label, placeholder
  static const Color textHint = Color(0xFFA8A29E); // hint — placeholder
  static const Color textOnDark = Color(
    0xFFFAFAF9,
  ); // koyu bg üzerindeki beyaz metin
  static const Color textOnAccent = Color(
    0xFF1C1917,
  ); // gold bg üzerindeki metin
  static const Color textAmber = Color(
    0xFF92703A,
  ); // krem bg üzerindeki altın metin

  static const Color border = Color(0xFFE7E5E4); // input, kart border
  static const Color borderMid = Color(0xFFD6CFC7); // chip border
  static const Color borderDark = Color(0xFF3C3530); // dark modda border

  static const Color error = Color(0xFFA32D2D); // hata — kırmızı
  static const Color errorLight = Color(0xFFFCA5A5); // hata border (sign out)
  static const Color success = Color(0xFF3B6D11); // başarı — yeşil
  static const Color warning = Color(0xFFD97706); // uyarı — amber
  static const Color warningLight = Color(0xFFFEF3C7); // uyarı bg

  static const Color matchBadge = Color(0xFFD4B483); // %92 match badge bg
  static const Color matchBadgeText = Color(0xFF1C1917); // match badge text

  static const Color navBackground = Color(0xFFFAFAF9); // light nav bg
  static const Color navBackgroundDark = Color(
    0xFF1C1917,
  ); // dark nav bg (AI ekranı)
  static const Color navActive = Color(0xFFD4B483); // aktif tab gold dot
  static const Color navInactive = Color(0xFF78716C); // pasif tab

  static const Color iconBgOrange = Color(0xFFF5F0E8); // edit profile icon
  static const Color iconBgRed = Color(0xFFFEE2E2); // notifications icon
  static const Color iconBgGreen = Color(0xFFD1FAE5); // location icon
  static const Color iconBgPurple = Color(0xFFEDE9FE); // privacy icon

  static const Color white = Colors.white;
  static const Color black = Colors.black;
}
