import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
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

                // ── Kilit ikonu ───────────────────────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🔒', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Başlık ────────────────────────────────────────────────
                Text(
                  LocaleKeys.authForgotPasswordTitle.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  LocaleKeys.authForgotPasswordSubtitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                ),

                const SizedBox(height: 32),

                // ── Email ─────────────────────────────────────────────────
                Text('Email address', style: AppTextStyles.labelLarge),
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

                // ── Send Reset Link butonu ────────────────────────────────
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
                          borderRadius: BorderRadius.circular(12),
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
                              style: const TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Adımlar ───────────────────────────────────────────────
                const _StepsList(),

                const SizedBox(height: 32),

                // ── Alt link ──────────────────────────────────────────────
                AuthBottomLink(
                  question: LocaleKeys.authRememberedPassword.tr(),
                  actionText: LocaleKeys.authBackToSignIn.tr(),
                  onTap: () {
                    // context.go(AppRoutes.login);
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

// ── Adımlar ───────────────────────────────────────────────────────────────────

class _StepsList extends StatelessWidget {
  const _StepsList();

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
              Expanded(child: Text(_steps[i], style: AppTextStyles.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
