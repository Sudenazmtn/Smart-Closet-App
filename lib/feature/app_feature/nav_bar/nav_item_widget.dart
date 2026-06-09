import 'package:flutter/material.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_item_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class NavItemWidget extends StatelessWidget {
  const NavItemWidget({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isActive ? item.activeIcon : item.icon,
            size: AppSizes.l,
            color: isActive ? AppColors.textPrimary : AppColors.textMuted,
          ),
          const SizedBox(height: AppSizes.xxs),
          Text(
            item.label,
            style: isActive
                ? AppTextStyles.navLabelActive
                : AppTextStyles.navLabelInactive,
          ),
          const SizedBox(height: AppSizes.xxs),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? AppSizes.navIndicatorW : 0,
            height: AppSizes.xxxs,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: AppRadius.allXXXS,
            ),
          ),
        ],
      ),
    );
  }
}
