// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'utils/theme.dart';
import 'utils/language_provider.dart';
import 'utils/theme_provider.dart';
import 'services/analysis_service.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final String languageCode = prefs.getString('languageCode') ?? 'fr';
  
  // Charger le modèle au démarrage de l'application
  try {
    await AnalysisService.loadModel();
    debugPrint('Modèle chargé avec succès au démarrage');
  } catch (e) {
    debugPrint('Erreur lors du chargement du modèle au démarrage: $e');
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(isDarkMode),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(languageCode),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Tri Automatique des Prunes',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(languageProvider.languageCode),
          supportedLocales: const [
            Locale('fr', ''), // Français
            Locale('en', ''), // Anglais
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashScreen(),
        );
      },
    );
  }
}