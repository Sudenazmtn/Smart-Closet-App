import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AuthBottomLink extends StatelessWidget {
  const AuthBottomLink({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
  });

  final String question;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question, style: AppTextStyles.buttonSecondary),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: Text(actionText, style: AppTextStyles.authLink),
        ),
      ],
    );
  }
}
