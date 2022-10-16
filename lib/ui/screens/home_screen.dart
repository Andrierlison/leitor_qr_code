import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leitor_qr_code/admob.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/screens/qr_screen.dart';
import 'package:leitor_qr_code/ui/widgets/custom_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _headerBanner;

  void _initScreen() async {
    _headerBanner = BannerAd(
      adUnitId: homeBannerAdId,
      size: AdSize.largeBanner,
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

  Future _goToScan({required BuildContext context}) async {
    final hasPermission = await _verifyCameraPermission();

    if (mounted && hasPermission) {
      return Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const QRScreen()),
      );
    } else {
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
                      margin: const EdgeInsets.all(2),
                      child: Text(
                        AppLocalizations.of(context).cameraRequest,
                        style: const TextStyle(fontSize: 18),
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
                              color: customBlack,
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
    }
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
                child: Text(
                  AppLocalizations.of(context).yourOpinion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                    label: AppLocalizations.of(context).rate,
                    iconName: Icons.shop_outlined,
                    onPressed: () async {
                      String url =
                          'https://play.google.com/store/apps/details?id=com.andrierlison.leitor_qr_code';
                      bool canLaunch = await canLaunchUrl(Uri.parse(url));

                      if (canLaunch) {
                        launchUrl(
                          Uri.parse(url),
                          mode: LaunchMode.externalApplication,
                        );
                      }
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

  Widget _button({
    required String label,
    required void Function()? onPress,
    required IconData iconName,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width / 1.5,
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(customBlack),
        ),
        onPressed: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconName),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  void dispose() {
    _headerBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        actions: [
          IconButton(
            onPressed: () => _rateModal(context: context),
            icon: const Icon(Icons.favorite),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                      iconName: Icons.qr_code_scanner_outlined,
                      label: AppLocalizations.of(context).openReader,
                      onPress: () => _goToScan(context: context),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                      iconName: Icons.history,
                      label: AppLocalizations.of(context).openHistory,
                      onPress: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HistoryScreen(),
                        ),
                      ),
                    ),
                  ],
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
