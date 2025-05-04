import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/language/screens/language_select_screen.dart';
import '../features/profile_setup/screens/profile_setup_screen.dart';
import '../features/song_view/screens/song_view_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageSelectScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/song-view',
      builder: (context, state) => const SongViewScreen(),
    ),
    GoRoute(
      path: '/',
      redirect: (context, state) => '/language',
    ),
  ],
);
