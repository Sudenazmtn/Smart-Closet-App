import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_closet_app/feature/auth/views/widget/auth_visibilty_icon.dart';
import 'package:smart_closet_app/product/init/localization/locale_keys.dart';
import 'package:smart_closet_app/product/init/routes/app_router.dart';
import 'package:smart_closet_app/product/utils/constant/app_color.dart';
import 'package:smart_closet_app/product/utils/constant/app_radius.dart';
import 'package:smart_closet_app/product/utils/constant/app_size.dart';
import 'package:smart_closet_app/product/utils/constant/app_text_styles.dart';

import '../provider/auth_provider.dart';
import 'mixin/sign_up_mixin.dart';
import 'widget/auth_bottom_link.dart';
import 'widget/auth_form_field.dart';
import 'widget/auth_google_button.dart';
import 'widget/auth_logo_header.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with SignUpMixin {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan
          Column(
            children: [
              Container(
                height: screenHeight * 0.32,
                color: AppColors.accentLight,
              ),
              Expanded(child: Container(color: AppColors.accentLight)),
            ],
          ),

          // İçerik
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.xl),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 52),
                    const AuthLogoHeader(),
                    const SizedBox(height: 32),

                    // ── Beyaz kart ─────────────────────────────────────────
                    Container(
                      padding: EdgeInsets.all(AppSizes.l),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.allL,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Full Name
                          AuthFormField(
                            controller: nameController,
                            hintText: LocaleKeys.fieldFullName.tr(),
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return LocaleKeys.validationRequired.tr(
                                  args: [LocaleKeys.fieldFullName.tr()],
                                );
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Email
                          AuthFormField(
                            controller: emailController,
                            hintText: LocaleKeys.fieldEmail.tr(),
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
                          const SizedBox(height: 10),

                          // Password
                          AuthFormField(
                            controller: passwordController,
                            hintText: LocaleKeys.fieldPassword.tr(),
                            obscureText: obscurePassword,
                            suffixIcon: AuthVisibilityIcon(
                              obscure: obscurePassword,
                              onTap: togglePasswordVisibility,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validationRequired.tr(
                                  args: [LocaleKeys.fieldPassword.tr()],
                                );
                              }
                              if (v.length < 8) {
                                return LocaleKeys.validationPasswordShort.tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),

                          // Confirm Password
                          AuthFormField(
                            controller: confirmPasswordController,
                            hintText: LocaleKeys.fieldConfirmPassword.tr(),
                            obscureText: obscureConfirmPassword,
                            suffixIcon: AuthVisibilityIcon(
                              obscure: obscureConfirmPassword,
                              onTap: toggleConfirmPasswordVisibility,
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validationRequired.tr(
                                  args: [LocaleKeys.fieldConfirmPassword.tr()],
                                );
                              }
                              if (v != passwordController.text) {
                                return LocaleKeys.validationPasswordMismatch
                                    .tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Create Account butonu
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: auth.isLoading
                                    ? null
                                    : () => onCreateAccount(context),
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
                                        LocaleKeys.authSignUp.tr(),
                                        style: AppTextStyles.buttonAccent,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Google butonu
                          AuthGoogleButton(
                            onTap: () => onGoogleSignIn(context),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Alt link
                    AuthBottomLink(
                      question: LocaleKeys.authAlreadyHaveAccount.tr(),
                      actionText: LocaleKeys.authSignIn.tr(),
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
        ],
      ),
    );
  }
}
