import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class StepsList extends StatelessWidget {
  const StepsList({super.key});

  static const List<String> _steps = [
    'Check your inbox for an email from SmartCloset.',
    'Click the link to create a new password.',
    'Log in with your new password.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        _steps.length,
        (index) => _StepItem(number: index + 1, text: _steps[index]),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
