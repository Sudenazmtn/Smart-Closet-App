import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

import '../provider/auth_provider.dart';
import 'mixin/forgot_password_mixin.dart';
import 'widget/auth_bottom_link.dart';
import 'widget/auth_form_field.dart';
import 'widget/auth_logo_header.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView>
    with ForgotPasswordMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 52),
                const AuthLogoHeader(),
                const SizedBox(height: 40),

                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🔒', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  LocaleKeys.authForgotPasswordTitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  LocaleKeys.authForgotPasswordSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                ),

                const SizedBox(height: 32),

                Text(LocaleKeys.fieldEmail.tr(), style: AppTextStyles.labelLarge),
                const SizedBox(height: 8),
                AuthFormField(
                  controller: emailController,
                  hintText: LocaleKeys.fieldHintEmail.tr(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return LocaleKeys.validationRequired.tr(
                        args: [LocaleKeys.fieldEmail.tr()],
                      );
                    }
                    if (!v.contains('@')) {
                      return LocaleKeys.validationEmailInvalid.tr();
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                Consumer<AuthProvider>(
                  builder: (context, auth, _) => SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: auth.isLoading
                          ? null
                          : () => onSendResetLink(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.allS,
                        ),
                      ),
                      child: auth.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              LocaleKeys.authSendResetLink.tr(),
                              style: AppTextStyles.buttonAccent,
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const _StepsList(),

                const SizedBox(height: 32),

                AuthBottomLink(
                  question: LocaleKeys.authRememberedPassword.tr(),
                  actionText: LocaleKeys.authBackToSignIn.tr(),
                  onTap: () {
                    context.go(AppRoutes.login);
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepsList extends StatelessWidget {
  const _StepsList();

  @override
  Widget build(BuildContext context) {
    final steps = [
      LocaleKeys.authResetStep1.tr(),
      LocaleKeys.authResetStep2.tr(),
      LocaleKeys.authResetStep3.tr(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        steps.length,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${i + 1}. ',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(child: Text(steps[i], style: AppTextStyles.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
