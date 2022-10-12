import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:leitor_qr_code/admob.dart';
import 'package:leitor_qr_code/ui/widgets/custom_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

  Widget _buildQrView(BuildContext context) {
    double scanArea = MediaQuery.of(context).size.width / 1.7;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _toggleFlash() async {
    try {
      await controller?.toggleFlash();

      bool result = await controller?.getFlashStatus() ?? false;

      setState(() {
        flashStatus = result;
      });
    } catch (error) {
      log(error.toString());
    }
  }

  void copyToClipBoard() async {
    await Clipboard.setData(ClipboardData(text: result?.code.toString()));
  }

  void _initScreen() async {
    _footerBanner = BannerAd(
      adUnitId: scanBannerAdId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    if (_footerBanner != null) {
      await _footerBanner!.load();
    }
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
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
                          result!.code ?? '',
                        ),
                        CustomButton(
                            label: 'Copiar', onPressed: () => copyToClipBoard())
                      ],
                    )
                  else
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: const Text(
                        'Escanei um codigo',
                        style: TextStyle(
                          fontSize: 30,
                        ),
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
