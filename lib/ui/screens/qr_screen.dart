// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:leitor_qr_code/admob.dart';
import 'package:leitor_qr_code/data/datasources/cache/save_history_cache_datasource_imp.dart';
import 'package:leitor_qr_code/data/repositories/save_history_repository_imp.dart';
import 'package:leitor_qr_code/domain/entities/history_entity.dart';
import 'package:leitor_qr_code/domain/usecases/save_history/save_history_usecase_imp.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/widgets/custom_button.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _QRViewScreenState();
}

class _QRViewScreenState extends State<QRScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;
  QRViewController? controller;

  bool flashStatus = false;

  BannerAd? _footerBanner;

  bool _isTextCopied = false;

  Widget _buildQrView(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width / 1.7;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 10,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  Future<void> _modalWithResult() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter changer) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Wrap(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      result!.code!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: customBlack,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        label: _isTextCopied
                            ? AppLocalizations.of(context)!.copied
                            : AppLocalizations.of(context)!.copy,
                        iconName: Icons.copy,
                        onPressed: () {
                          copyToClipBoard(changer);

                          changer(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _saveHistory(String name) async {
    final SaveHistoryUseCaseImp saveHistoryUseCaseImp = SaveHistoryUseCaseImp(
      SaveHistoryRepositoryImp(SaveHistoryCacheDataSourceImp()),
    );

    await saveHistoryUseCaseImp.call(
      item: HistoryEntity(
        name: name,
        dateInsert: DateTime.now().toString(),
        isFavorite: false,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null && result!.code!.isNotEmpty) {
        await _saveHistory(result!.code!);

        if (result!.code!.length > 50) {
          controller.pauseCamera();

          return _modalWithResult();
        } else {
          controller.pauseCamera();
        }
      }
    });

    controller.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).cameraRequestDenied),
        ),
      );
    }
  }

  Future<void> _toggleFlash() async {
    await controller?.toggleFlash();

    bool result = await controller?.getFlashStatus() ?? false;

    setState(() {
      flashStatus = result;
    });
  }

  Future<void> copyToClipBoard(setter) async {
    await Clipboard.setData(ClipboardData(text: result?.code.toString()));

    if (mounted) {
      setter(() {
        _isTextCopied = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setter(() {
        _isTextCopied = false;
      });
    }
  }

  void _initScreen() async {
    _footerBanner = BannerAd(
      adUnitId: scanBannerAdId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    if (_footerBanner != null) {
      await _footerBanner!.load();
    }

    if (controller != null) controller!.resumeCamera();
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    _footerBanner?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).appTitle)),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Row(
                      children: [
                        Text(
                          result!.code!.length > 30
                              ? '${result!.code!.substring(0, 30)}...'
                              : result!.code!,
                        ),
                        CustomButton(
                          label: _isTextCopied
                              ? AppLocalizations.of(context).copied
                              : AppLocalizations.of(context).copy,
                          onPressed: () => copyToClipBoard(setState),
                        )
                      ],
                    )
                  else
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        AppLocalizations.of(context).scanACode,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                        label: '',
                        iconName:
                            flashStatus ? Icons.flash_on : Icons.flash_off,
                        onPressed: () => _toggleFlash(),
                      ),
                      FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          return CustomButton(
                            label: '',
                            iconName: Icons.cameraswitch_outlined,
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                          );
                        },
                      ),
                      CustomButton(
                        label: '',
                        iconName: Icons.pause,
                        onPressed: () async {
                          await controller?.pauseCamera();
                        },
                      ),
                      CustomButton(
                        label: '',
                        iconName: Icons.play_arrow,
                        onPressed: () async {
                          await controller?.resumeCamera();
                        },
                      ),
                      CustomButton(
                        label: '',
                        iconName: Icons.history,
                        onPressed: () {
                          controller!.dispose();

                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
                          Navigator.of(context).pushNamed('/history');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_footerBanner != null)
            Expanded(flex: 1, child: AdWidget(ad: _footerBanner!)),
        ],
      ),
    );
  }
}
