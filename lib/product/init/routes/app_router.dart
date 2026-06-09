import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_closet_app/feature/add_clothing/view/add_clothing_view.dart';
import 'package:smart_closet_app/feature/auth/views/forgot_password_view.dart';
import 'package:smart_closet_app/feature/auth/views/onboarding_view.dart';
import 'package:smart_closet_app/feature/auth/views/sign_in_view.dart';
import 'package:smart_closet_app/feature/auth/views/sign_up_view.dart';
import 'package:smart_closet_app/feature/home/view/home_view.dart';
import 'package:smart_closet_app/feature/outfit/view/outfit_view.dart';
import 'package:smart_closet_app/feature/profile/view/profile_view.dart';
import 'package:smart_closet_app/feature/stats/view/stats_view.dart';
import 'package:smart_closet_app/feature/wardrobe/view/wardrobe_view.dart';
import 'package:smart_closet_app/feature/saved_outfits/view/saved_outfits_view.dart';

class AppRoutes {
  AppRoutes._();

  static const onboarding = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const wardrobe = '/wardrobe';
  static const addClothing = '/wardrobe/add';
  static const outfit = '/outfit';
  static const stats = '/stats';
  static const profile        = '/profile';
  static const savedOutfits   = '/saved-outfits';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  debugLogDiagnostics: true,

  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute =
        state.matchedLocation == AppRoutes.onboarding ||
        state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.register ||
        state.matchedLocation == AppRoutes.forgotPassword;

    if (isLoggedIn && isAuthRoute) return AppRoutes.home;
    if (!isLoggedIn && !isAuthRoute) return AppRoutes.onboarding;
    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const SignInView(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const SignUpView(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: AppRoutes.wardrobe,
      name: 'wardrobe',
      builder: (context, state) => const WardrobeView(),
      routes: [
        GoRoute(
          path: 'add',
          name: 'addClothing',
          builder: (context, state) => const AddClothingView(),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.outfit,
      name: 'outfit',
      builder: (context, state) => const OutfitView(),
    ),
    GoRoute(
      path: AppRoutes.stats,
      name: 'stats',
      builder: (context, state) => const StatsView(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: 'profile',
      builder: (context, state) => const ProfileView(),
    ),
    GoRoute(
      path: AppRoutes.savedOutfits,
      name: 'savedOutfits',
      builder: (context, state) => const SavedOutfitsView(),
    ),
  ],

  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Sayfa bulunamadı: ${state.error}'))),
);
