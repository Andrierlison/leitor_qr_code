import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leitor_qr_code/admob.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/screens/qr_screen.dart';
import 'package:leitor_qr_code/ui/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
      adUnitId: homeBannerAdId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    if (_headerBanner != null) {
      await _headerBanner!.load();
    }
  }

  Future<bool> _verifyCameraPermission() async {
    PermissionStatus cameraPermission = await Permission.camera.status;

    if (cameraPermission.isDenied ||
        cameraPermission.isPermanentlyDenied ||
        cameraPermission.isLimited ||
        cameraPermission.isRestricted) {
      await Permission.camera.request();
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

  Future<void> _rateModal({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'Sua opinião é muito importante, deixe sua avaliação sobre o nosso app para ele continuar melhorando!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: customBlack,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    label: 'Avaliar',
                    iconName: Icons.shop_outlined,
                    onPressed: () async {
                      String url =
                          'https://play.google.com/store/apps/details?id=com.andrierlison.leitor_qr_code';
                      bool canLaunch = await canLaunchUrl(Uri.parse(url));

                      if (canLaunch) launchUrl(Uri.parse(url));
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        actions: [
          IconButton(
            onPressed: () => _rateModal(context: context),
            icon: const Icon(Icons.favorite),
          )
        ],
      ),
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
