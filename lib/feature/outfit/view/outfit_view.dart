import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/app_feature/nav_bar/nav_bar.dart';
import 'package:smart_closet_app/feature/outfit/view/mixin/outfit_mixin.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_chat_bubble.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_input_bar.dart';
import 'package:smart_closet_app/feature/outfit/view/widget/outfit_suggestion_row.dart';
import 'package:smart_closet_app/feature/wardrobe/provider/outfit_provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_paddings.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

class OutfitView extends StatefulWidget {
  const OutfitView({super.key});

  @override
  State<OutfitView> createState() => _OutfitViewState();
}

class _OutfitViewState extends State<OutfitView> with OutfitMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            const _OutfitHeader(),
            Expanded(
              child: _MessageList(scrollController: scrollController),
            ),
            Consumer<OutfitProvider>(
              builder: (context, outfit, _) => OutfitInputBar(
                controller: inputController,
                onSend: onSend,
                isLoading: outfit.isLoading,
              ),
            ),
            const AppBottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}

class _OutfitHeader extends StatelessWidget {
  const _OutfitHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.allS,
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.l,
            height: AppSizes.l,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: AppSizes.s,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.outfitTitle.tr(),
                style: AppTextStyles.headingSmall,
              ),
              Text(
                LocaleKeys.outfitAiLabel.tr(),
                style: AppTextStyles.labelTag,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  const _MessageList({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Consumer<OutfitProvider>(
      builder: (context, outfit, _) {
        final messages = outfit.messages;
        return ListView.builder(
          controller: scrollController,
          padding: AppPaddings.allM,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OutfitChatBubble(message: msg),
                if (msg.suggestedItems != null &&
                    msg.suggestedItems!.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.xs),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSizes.xxs),
                    child: OutfitSuggestionRow(
                      items          : msg.suggestedItems!,
                      styleTip       : msg.styleTip,
                      destinationCity: msg.destinationCity,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
