import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/data/services/api_service.dart';

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
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: imageUrl != null ? AppColors.accentLight : color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl != null
                  ? Image.network(
                      '${ApiService.baseUrl}$imageUrl',
                      width: 72,
                      height: 72,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) =>
                          Center(child: Text(emoji, style: const TextStyle(fontSize: 30))),
                    )
                  : Center(child: Text(emoji, style: const TextStyle(fontSize: 30))),
            ),
          ),
          
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'DMSans',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
