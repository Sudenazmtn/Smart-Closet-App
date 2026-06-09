import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/enums/auth_status_enum.dart';

import '../../provider/auth_provider.dart';

mixin ForgotPasswordMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> onSendResetLink(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    await auth.sendPasswordResetEmail(emailController.text.trim());
    if (!mounted) return;
    if (auth.status == AuthStatus.success) {
      messenger.showSnackBar(SnackBar(
        content: Text(LocaleKeys.successResetEmailSent.tr()),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allSoft),
      ));
      router.go(AppRoutes.login);
    } else if (auth.status == AuthStatus.error) {
      messenger.showSnackBar(SnackBar(
        content: Text((auth.errorMessage ?? '').tr()),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allSoft),
      ));
    }
  }

}
