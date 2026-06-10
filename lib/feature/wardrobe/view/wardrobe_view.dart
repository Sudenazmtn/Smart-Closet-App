import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/feature/wardrobe/view/widget/header.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/enums/clothing_status_enum.dart';

import '../provider/clothing_provider.dart';
import 'mixin/wardrobe_mixin.dart';
import 'widget/wardrobe_empty_state.dart';
import 'widget/wardrobe_filter_row.dart';
import 'widget/wardrobe_grid.dart';

part 'wardrobe_view_filter.dart';

class WardrobeView extends StatefulWidget {
  const WardrobeView({super.key});

  @override
  State<WardrobeView> createState() => _WardrobeViewState();
}

class _WardrobeViewState extends State<WardrobeView> with WardrobeMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ClothingProvider>(
              builder: (context, clothing, _) => WardrobeHeader(
                itemCount: clothing.totalItems,
                onAddTap: () {
                  context.go(AppRoutes.addClothing);
                },
              ),
            ),
            const SizedBox(height: 12),
            Consumer<ClothingProvider>(
              builder: (context, clothing, _) => WardrobeFilterRow(
                filters: wardrobeFilters,
                selectedValue: clothing.selectedFilter,
                onFilterTap: onFilterChanged,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<ClothingProvider>(
                builder: (context, clothing, _) {
                  if (clothing.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    );
                  }
                  if (clothing.status == ClothingStatus.error) {
                    return WardrobeErrorState(
                      message: clothing.errorMessage ?? '',
                      onRetry: onRetry,
                    );
                  }
                  if (clothing.items.isEmpty) {
                    return const WardrobeEmptyState();
                  }
                  return WardrobeGrid(
                    items: clothing.items,
                    onItemTap: (item) =>
                        context.push(AppRoutes.clothingDetail, extra: item),
                    onItemLongPress: (item) => onDeleteItem(item.id),
                  );
                },
              ),
            ),
            const AppBottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }
}
