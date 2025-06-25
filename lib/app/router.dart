import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/language/screens/language_select_screen.dart';
import '../features/profile_setup/screens/profile_setup_screen.dart';
import '../features/song_view/screens/song_view_screen.dart';
import '../features/song_view/screens/song_settings_screen.dart';
import '../features/song_view/screens/song_edit_screen.dart';
import '../features/song_view/screens/song_search_screen.dart';

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
    GoRoute(
      path: '/song-view',
      builder: (context, state) => const SongViewScreen(),
    ),
    GoRoute(
      path: '/song-settings',
      builder: (context, state) => const SongSettingsScreen(
        textFontSize: 18,
        chordFontSize: 20,
        textColor: Colors.black,
        chordColor: Colors.blue,
        scrollUp: 3,
        scrollDown: 5,
      ),
    ),
    GoRoute(
      path: '/song-edit',
      builder: (context, state) => const SongEditScreen(filePath: ''),
    ),
    GoRoute(
      path: '/song-search',
      builder: (context, state) => const SongSearchScreen(),
    ),
  ],
);
