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
  static const primaryColor = Color(0xFF6D3FC0);
  static const goldColor = Color(0xFFB794F4);
  static const beigeColor = Color(0xFFF7F9FC);
  static const pinkBeige = Color.fromARGB(255, 219, 196, 232);

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
        scaffoldBackgroundColor: const Color(0xFF1F1A2B),
        cardColor: const Color(0xFF1F1A2B),
        fontFamily: 'Cairo',
      ),
      themeMode: themeProvider.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}