// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:leitor_qr_code/admob.dart';
import 'package:leitor_qr_code/infra/helpers/advertising.dart';
import 'package:leitor_qr_code/infra/helpers/capture_widget.dart';
import 'package:leitor_qr_code/infra/helpers/permissions_helper.dart';
import 'package:leitor_qr_code/infra/helpers/share.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/widgets/custom_button.dart';
import 'package:leitor_qr_code/ui/widgets/custom_modal.dart';
import 'package:leitor_qr_code/ui/widgets/qr_code_widget.dart';
import 'package:leitor_qr_code/ui/widgets/screen_background.dart';

class CreatePixCodeScreen extends StatefulWidget {
  const CreatePixCodeScreen({Key? key}) : super(key: key);
  @override
  State<CreatePixCodeScreen> createState() => _CreatePixCodeScreenState();
}

class _CreatePixCodeScreenState extends State<CreatePixCodeScreen> {
  final TextEditingController _fieldQRCodeData = TextEditingController();

  final GlobalKey _codeGeneratedCode = GlobalKey();

  final Advertising advertising = Advertising();

  BannerAd? _footerBanner;

  bool _showDataWithCode = false;

  Future<void> _modalRequestStorage() async {
    final CustomModal customModal = CustomModal();

    return customModal.show(
      context: context,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Icon(
            Icons.save_outlined,
            size: 40,
            color: customGreen,
          ),
        ),
        Center(
          child: Text(
            AppLocalizations.of(context).storageRequest,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Future<bool> _canAccessStorage() async {
    final PermissionsHelper permissionsHelper = PermissionsHelper();

    bool canAccessStorage = await permissionsHelper.canAccessStorage();

    await permissionsHelper.requestStorage();

    return canAccessStorage;
  }

  Future<void> _generateQRCode() async {
    if (!await _canAccessStorage()) return _modalRequestStorage();

    advertising.showInterstitialAd();

    final CaptureWidget captureWidget = CaptureWidget();

    await captureWidget
        .capturePng(
      key: _codeGeneratedCode,
      fileName: _fieldQRCodeData.text,
    )
        .then((String value) {
      if (value.isEmpty) return;

      final CustomModal customModal = CustomModal();

      customModal.show(
        context: context,
        children: [
          const Center(
            child: Icon(
              Icons.check_circle_outlined,
              color: Colors.green,
              size: 60,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              AppLocalizations.of(context).savedAtDownloadsFolder,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: customBlack,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                iconName: Icons.share_outlined,
                label: AppLocalizations.of(context).share,
                onPressed: () => _shareFile(files: [value]),
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _shareFile({required List<String> files}) async {
    final ShareHelper shareHelper = ShareHelper();
    shareHelper.files(files: files);
  }

  Future<void> _previewCodeModal({required BuildContext context}) async {
    final CustomModal customModal = CustomModal();

    await customModal.show(
      context: context,
      title: AppLocalizations.of(context).preview,
      children: [
        Column(
          children: [
            RepaintBoundary(
              key: _codeGeneratedCode,
              child: Container(
                color: customWhite,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    QRCodeWidget(data: _fieldQRCodeData.text),
                    if (_showDataWithCode)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.pix_outlined,
                            color: customGreen,
                            size: 24,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _fieldQRCodeData.text,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  iconName: Icons.pix_outlined,
                  label: '${AppLocalizations.of(context).createCode} Pix',
                  onPressed: () => _generateQRCode(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _initScreen() async {
    _footerBanner = BannerAd(
      adUnitId: generateQRCodeBannerAdId,
      size: AdSize.largeBanner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    advertising.createInterstitialAd();

    if (_footerBanner != null) {
      await _footerBanner!.load();
    }
  }

  @override
  void dispose() {
    super.dispose();
    advertising.interstitialAd?.dispose();
    _footerBanner?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBarTitle: '${AppLocalizations.of(context).createCode} Pix',
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _fieldQRCodeData,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).typeHereToShowTheCode,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: customBlack),
              ),
              hintStyle: const TextStyle(
                decoration: TextDecoration.none,
              ),
            ),
            onChanged: (text) => setState(() {}),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context).showText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Checkbox(
                  value: _showDataWithCode,
                  activeColor: customBlack,
                  onChanged: (value) {
                    setState(() {
                      _showDataWithCode = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: _fieldQRCodeData.text.isEmpty ? 0.7 : 1,
              child: CustomButton(
                iconName: Icons.play_arrow_outlined,
                label: AppLocalizations.of(context).preview,
                onPressed: () {
                  if (_fieldQRCodeData.text.isEmpty) return;

                  _previewCodeModal(context: context);
                },
              ),
            ),
          ],
        ),
        if (_footerBanner != null)
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: AdWidget(ad: _footerBanner!),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
