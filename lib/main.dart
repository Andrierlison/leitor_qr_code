// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Project imports:
import 'package:leitor_qr_code/screens_routes.dart';
import 'package:leitor_qr_code/sentry.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  MobileAds.instance.initialize();

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryKey;
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      MaterialApp(
        showSemanticsDebugger: false,
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: '/',
        routes: screensRoutes,
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
    ),
  );
}
