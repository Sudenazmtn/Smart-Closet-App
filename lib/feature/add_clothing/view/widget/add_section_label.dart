import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class AddSectionLabel extends StatelessWidget {
  const AddSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.labelLarge);
  }
}
