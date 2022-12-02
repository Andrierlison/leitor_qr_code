// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:leitor_qr_code/ui/screens/create_bar_code_screen.dart';
import 'package:leitor_qr_code/ui/screens/create_pix_code_screen.dart';
import 'package:leitor_qr_code/ui/screens/create_qr_code_screen.dart';
import 'package:leitor_qr_code/ui/screens/create_wifi_code_screen.dart';
import 'package:leitor_qr_code/ui/screens/history_screen.dart';
import 'package:leitor_qr_code/ui/screens/home_screen.dart';
import 'package:leitor_qr_code/ui/screens/qr_screen.dart';

final Map<String, WidgetBuilder> screensRoutes = {
  '/': (context) => const HomeScreen(),
  '/home': (context) => const HomeScreen(),
  '/history': (context) => const HistoryScreen(),
  '/scan_code': (context) => const QRScreen(),
  '/create/bar': (context) => const CreateBarCodeScreen(),
  '/create/pix': (context) => const CreatePixCodeScreen(),
  '/create/text': (context) => const CreateQRCodeScreen(),
  '/create/wifi': (context) => const CreateWiFiCodeScreen(),
};
