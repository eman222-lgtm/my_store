import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // الألوان الرئيسية
  static const primaryColor = Color(0xFF1B4332);
  static const goldColor = Color(0xFFC9A96E);
  static const beigeColor = Color(0xFFF5EFE6);
  static const pinkBeige = Color(0xFFE8D5C4);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'My Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: goldColor,
          background: beigeColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: beigeColor,
        cardColor: Colors.white,
        fontFamily: 'Cairo',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: primaryColor,
          secondary: goldColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0E0A),
        cardColor: const Color(0xFF1A2E1A),
        fontFamily: 'Cairo',
      ),
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}