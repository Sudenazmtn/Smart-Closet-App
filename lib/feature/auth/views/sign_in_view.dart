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
import 'mixin/sign_in_mixin.dart';
import 'widget/auth_bottom_link.dart';
import 'widget/auth_form_field.dart';
import 'widget/auth_logo_header.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> with SignInMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentLight,
      body: SafeArea(
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

                // ── Kart ──────────────────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(AppSizes.xl),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.allL,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        LocaleKeys.authSignInTitle.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headingMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LocaleKeys.authSignInSubtitle.tr(),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall,
                      ),
                      const SizedBox(height: 24),

                      // Email
                      Text(
                        LocaleKeys.fieldEmail.tr(),
                        style: AppTextStyles.labelLarge,
                      ),
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

                      const SizedBox(height: 16),

                      // Şifre
                      Text(
                        LocaleKeys.fieldPassword.tr(),
                        style: AppTextStyles.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      AuthFormField(
                        controller: passwordController,
                        hintText: LocaleKeys.fieldHintPassword.tr(),
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

                      // Şifremi unuttum
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.go(AppRoutes.forgotPassword);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            LocaleKeys.authForgotPassword.tr(),
                            style: AppTextStyles.buttonLink,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Sign In butonu
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: auth.isLoading
                                ? null
                                : () => onSignIn(context),
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
                                    LocaleKeys.authSignIn.tr(),
                                    style: AppTextStyles.buttonAccent,
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Güvenlik notu
                      Container(
                        padding: EdgeInsets.all(AppSizes.s),
                        decoration: BoxDecoration(
                          color: AppColors.accentLight,
                          borderRadius: AppRadius.allS,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.shield_outlined,
                              size: 18,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                LocaleKeys.authSecurityNote.tr(),
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Alt link
                AuthBottomLink(
                  question: LocaleKeys.authDontHaveAccount.tr(),
                  actionText: LocaleKeys.authSignUp.tr(),
                  onTap: () {
                    context.go(AppRoutes.register);
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
