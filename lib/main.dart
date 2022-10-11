import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(
    MaterialApp(
      showSemanticsDebugger: false,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: customBlack,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(),
        appBarTheme: const AppBarTheme(
          color: customBlack,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: customBlack,
        ),
      ),
      home: const HomeScreen(),
    ),
  );
}
