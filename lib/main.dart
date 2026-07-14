import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/auth/onboarding_screen.dart'; 
import 'screens/home/home_screen_new.dart';
import 'services/watchlist_service.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings_box'); 
  await WatchlistService.init();
  runApp(const AreaFilmApp());
}

class AreaFilmApp extends StatelessWidget {
  const AreaFilmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Area Film',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.card,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.card,
          selectedItemColor: AppColors.primary, 
          unselectedItemColor: AppColors.textSecondary,
          showUnselectedLabels: true,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}