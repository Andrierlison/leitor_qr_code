import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  MobileAds.instance.initialize();

  runApp(
    MaterialApp(
      showSemanticsDebugger: false,
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('pt', ''),
      ],
      home: const HomeScreen(),
    ),
  );
}
