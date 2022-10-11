import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/screens/qr_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String screenTitle = 'Leitor de QR code';

  BannerAd? _headerBanner;

  void _initScreen() async {
    _headerBanner = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    if (_headerBanner != null) {
      await _headerBanner!.load();
    }

    setState(() {});
  }

  Future<bool> _verifyCameraPermission() async {
    PermissionStatus cameraPermission = await Permission.camera.status;

    if (cameraPermission.isDenied ||
        cameraPermission.isPermanentlyDenied ||
        cameraPermission.isLimited ||
        cameraPermission.isRestricted) {
      await Permission.camera.request();

      return false;
    }

    cameraPermission = await Permission.camera.status;

    if (cameraPermission.isGranted) return true;

    return false;
  }

  Future<void> _goToScan({required BuildContext context}) async {
    await _verifyCameraPermission().then((value) {
      if (value) {
        return Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const QRScreen()),
        );
      }

      return showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              content: SizedBox(
                child: Wrap(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: const Text(
                        'Precisamos de permissão de acesso a câmera para escanear o QR Code',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(screenTitle)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(customBlack),
                  ),
                  onPressed: () => _goToScan(context: context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.qr_code_outlined),
                      SizedBox(width: 10),
                      Text('Abrir leitor'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_headerBanner != null)
            Expanded(flex: 1, child: AdWidget(ad: _headerBanner!)),
        ],
      ),
    );
  }
}
