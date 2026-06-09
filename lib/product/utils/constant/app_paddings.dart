import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';

final class AppPaddings {
  const AppPaddings._();

  static const EdgeInsets zero = EdgeInsets.zero;

  static const EdgeInsets allXXXS = EdgeInsets.all(AppSizes.xxxs);

  static const EdgeInsets allXXS = EdgeInsets.all(AppSizes.xxs);

  static const EdgeInsets allXS = EdgeInsets.all(AppSizes.xs);

  static const EdgeInsets allS = EdgeInsets.all(AppSizes.s);

  static const EdgeInsets allM = EdgeInsets.all(AppSizes.m);

  static const EdgeInsets allL = EdgeInsets.all(AppSizes.l);

  static const EdgeInsets allXL = EdgeInsets.all(AppSizes.xl);

  static const EdgeInsets allXXL = EdgeInsets.all(AppSizes.xxl);

  static const EdgeInsets horizontalXXXS = EdgeInsets.symmetric(
    horizontal: AppSizes.xxxs,
  );

  static const EdgeInsets horizontalXXS = EdgeInsets.symmetric(
    horizontal: AppSizes.xxs,
  );

  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(
    horizontal: AppSizes.xs,
  );

  static const EdgeInsets horizontalS = EdgeInsets.symmetric(
    horizontal: AppSizes.s,
  );

  static const EdgeInsets horizontalM = EdgeInsets.symmetric(
    horizontal: AppSizes.m,
  );

  static const EdgeInsets horizontalL = EdgeInsets.symmetric(
    horizontal: AppSizes.l,
  );

  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(
    horizontal: AppSizes.xl,
  );

  static const EdgeInsets horizontalXXL = EdgeInsets.symmetric(
    horizontal: AppSizes.xxl,
  );

  static const EdgeInsets verticalXXXS = EdgeInsets.symmetric(
    vertical: AppSizes.xxxs,
  );

  static const EdgeInsets verticalXXS = EdgeInsets.symmetric(
    vertical: AppSizes.xxs,
  );

  static const EdgeInsets verticalXS = EdgeInsets.symmetric(
    vertical: AppSizes.xs,
  );

  static const EdgeInsets verticalS = EdgeInsets.symmetric(
    vertical: AppSizes.s,
  );

  static const EdgeInsets verticalM = EdgeInsets.symmetric(
    vertical: AppSizes.m,
  );

  static const EdgeInsets verticalL = EdgeInsets.symmetric(
    vertical: AppSizes.l,
  );

  static const EdgeInsets verticalXL = EdgeInsets.symmetric(
    vertical: AppSizes.xl,
  );

  static const EdgeInsets verticalXXL = EdgeInsets.symmetric(
    vertical: AppSizes.xxl,
  );

  static const EdgeInsets screenH = EdgeInsets.symmetric(
    horizontal: AppSizes.screenH,
  );

  static const EdgeInsets screenHTop = EdgeInsets.fromLTRB(
    AppSizes.screenH, AppSizes.screenH, AppSizes.screenH, 0,
  );
}
