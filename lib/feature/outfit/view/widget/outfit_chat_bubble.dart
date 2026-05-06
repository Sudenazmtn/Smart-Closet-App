import 'package:flutter/material.dart';
import 'package:smart_closet_app/product/data/model/chat_message_model.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class OutfitChatBubble extends StatelessWidget {
  const OutfitChatBubble({super.key, required this.message});
  final ChatMessageModel message;

  bool get _isAi => message.sender == MessageSender.ai;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: EdgeInsets.only(
          left: _isAi ? AppSizes.zero : AppSizes.xxl,
          right: _isAi ? AppSizes.xxl : AppSizes.zero,
          bottom: AppSizes.xs,
        ),
        padding: AppPaddings.allS,
        decoration: BoxDecoration(
          color: _isAi ? AppColors.backgroundCard : AppColors.accent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppSizes.s),
            topRight: const Radius.circular(AppSizes.s),
            bottomLeft: Radius.circular(_isAi ? AppSizes.xxs : AppSizes.s),
            bottomRight: Radius.circular(_isAi ? AppSizes.s : AppSizes.xxs),
          ),
          border: _isAi
              ? Border.all(color: AppColors.border)
              : null,
        ),
        child: Text(
          message.text,
          style: _isAi
              ? AppTextStyles.bodyMedium
              : AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textOnAccent,
                ),
        ),
      ),
    );
  }
}
