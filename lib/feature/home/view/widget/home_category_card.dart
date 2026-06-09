import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class HomeCategoryCard extends StatelessWidget {
  const HomeCategoryCard({
    super.key,
    required this.label,
    required this.emoji,
    required this.color,
    required this.onTap,
    this.imageUrl,
  });

  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: AppSizes.categoryCard,
            height: AppSizes.categoryCard,
            decoration: BoxDecoration(
              color: imageUrl != null ? AppColors.accentLight : color,
              borderRadius: AppRadius.allM,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.allM,
              child: imageUrl != null
                  ? Image.network(
                      '${ApiService.baseUrl}$imageUrl',
                      width: AppSizes.categoryCard,
                      height: AppSizes.categoryCard,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: AppSizes.emojiM),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: AppSizes.emojiM),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
