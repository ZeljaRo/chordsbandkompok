import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/language/screens/language_select_screen.dart';
import '../features/profile_setup/screens/profile_setup_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/language',
  routes: [
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
  ],
);
