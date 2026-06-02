import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
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
        backgroundColor: const Color(0xFF3B6D11),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      router.go(AppRoutes.login);
    } else if (auth.status == AuthStatus.error) {
      messenger.showSnackBar(SnackBar(
        content: Text((auth.errorMessage ?? '').tr()),
        backgroundColor: const Color(0xFFA32D2D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    }
  }

}
