import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';

final class AppRadius {
  const AppRadius._();

  static const BorderRadius zero = BorderRadius.zero;

  static const BorderRadius allXXS = BorderRadius.all(
    Radius.circular(AppSizes.xxs),
  );

  static const BorderRadius allXS = BorderRadius.all(
    Radius.circular(AppSizes.xs),
  );

  static const BorderRadius allS = BorderRadius.all(
    Radius.circular(AppSizes.s),
  );

  static const BorderRadius allM = BorderRadius.all(
    Radius.circular(AppSizes.m),
  );

  static const BorderRadius allL = BorderRadius.all(
    Radius.circular(AppSizes.l),
  );

  static const BorderRadius allXL = BorderRadius.all(
    Radius.circular(AppSizes.xl),
  );

  static const BorderRadius allXXL = BorderRadius.all(
    Radius.circular(AppSizes.xxl),
  );

  static const BorderRadius allXXXS = BorderRadius.all(
    Radius.circular(AppSizes.xxxs), // 2 — drag handles
  );

  static const BorderRadius allSoft = BorderRadius.all(
    Radius.circular(10), // dialogs, snackbars
  );

  static const BorderRadius allCard = BorderRadius.all(
    Radius.circular(14), // cards, pills, weather
  );

  static const BorderRadius pill = BorderRadius.all(
    Radius.circular(AppSizes.screenH), // 20 — pill buttons/badges
  );

  static const BorderRadius topL = BorderRadius.vertical(
    top: Radius.circular(AppSizes.l), // 24 — bottom sheets
  );

  static const BorderRadius bottomXL = BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.xl),
    bottomRight: Radius.circular(AppSizes.xl),
  );
}
