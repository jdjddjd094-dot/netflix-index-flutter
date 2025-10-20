import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants/app_colors.dart';
import 'l10n/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/content_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.netflixBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(const NetflixCloneApp());
}

class NetflixCloneApp extends StatelessWidget {
  const NetflixCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Netflix',
            debugShowCheckedModeBanner: false,
            
            // Localization
            locale: Locale(authProvider.language),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            
            // Theme
            theme: ThemeData(
              primarySwatch: Colors.red,
              primaryColor: AppColors.netflixRed,
              scaffoldBackgroundColor: AppColors.netflixBlack,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.netflixBlack,
                foregroundColor: AppColors.netflixWhite,
                elevation: 0,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AppColors.netflixWhite),
                bodyMedium: TextStyle(color: AppColors.netflixWhite),
                titleLarge: TextStyle(color: AppColors.netflixWhite),
                titleMedium: TextStyle(color: AppColors.netflixWhite),
                titleSmall: TextStyle(color: AppColors.netflixWhite),
              ),
              colorScheme: const ColorScheme.dark(
                primary: AppColors.netflixRed,
                secondary: AppColors.netflixRed,
                surface: AppColors.netflixDarkGray,
                background: AppColors.netflixBlack,
                onPrimary: AppColors.netflixWhite,
                onSecondary: AppColors.netflixWhite,
                onSurface: AppColors.netflixWhite,
                onBackground: AppColors.netflixWhite,
              ),
              useMaterial3: false,
            ),
            
            // Home
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Wait for auth initialization
    while (authProvider.isLoading) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    if (mounted) {
      if (authProvider.isSignedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.netflixBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Netflix Logo
            Icon(
              Icons.play_circle_filled,
              size: 100,
              color: AppColors.netflixRed,
            ),
            SizedBox(height: 20),
            Text(
              'NETFLIX',
              style: TextStyle(
                color: AppColors.netflixRed,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 40),
            CircularProgressIndicator(
              color: AppColors.netflixRed,
            ),
          ],
        ),
      ),
    );
  }
}