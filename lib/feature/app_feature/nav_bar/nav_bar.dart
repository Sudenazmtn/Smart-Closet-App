import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_item_model.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_item_widget.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  static final List<NavItem> _items = [
    NavItem(
      label: 'Home',
      route: AppRoutes.home,
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    NavItem(
      label: 'Wardrobe',
      route: AppRoutes.wardrobe,
      icon: Icons.checkroom_outlined,
      activeIcon: Icons.checkroom_rounded,
    ),
    NavItem(
      label: 'AI',
      route: AppRoutes.outfit,
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
    ),
    NavItem(
      label: 'Profile',
      route: AppRoutes.profile,
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              _items.length,
              (index) => Expanded(
                child: NavItemWidget(
                  item: _items[index],
                  isActive: currentIndex == index,
                  onTap: () => _onTap(context, index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    context.go(_items[index].route);
  }
}
