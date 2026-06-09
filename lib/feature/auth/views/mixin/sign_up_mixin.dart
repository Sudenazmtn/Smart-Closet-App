import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/enums/auth_status_enum.dart';

import '../../provider/auth_provider.dart';

mixin SignUpMixin<T extends StatefulWidget> on State<T> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() =>
      setState(() => obscurePassword = !obscurePassword);

  void toggleConfirmPasswordVisibility() =>
      setState(() => obscureConfirmPassword = !obscureConfirmPassword);

  Future<void> onCreateAccount(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    await auth.signUp(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;
    if (auth.status == AuthStatus.success) {
      router.go(AppRoutes.home);
    } else if (auth.status == AuthStatus.error) {
      _showError(messenger, auth.errorMessage ?? '');
    }
  }

  Future<void> onGoogleSignIn(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    await auth.signInWithGoogle();
    if (!mounted) return;
    if (auth.status == AuthStatus.success) {
      router.go(AppRoutes.home);
    } else if (auth.status == AuthStatus.error) {
      _showError(messenger, auth.errorMessage ?? '');
    }
  }

  void _showError(ScaffoldMessengerState messenger, String messageKey) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(messageKey.tr()),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allSoft),
      ),
    );
  }
}
