import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';

class AuthVisibilityIcon extends StatelessWidget {
  const AuthVisibilityIcon({
    super.key,
    required this.obscure,
    required this.onTap,
  });

  final bool obscure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.textMuted,
        size: 20,
      ),
      onPressed: onTap,
    );
  }
}
