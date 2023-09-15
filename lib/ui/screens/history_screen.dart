// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Project imports:
import 'package:leitor_qr_code/admob.dart';
import 'package:leitor_qr_code/data/datasources/cache/delete_history_cache_datasource_imp.dart';
import 'package:leitor_qr_code/data/datasources/cache/get_history_cache_datasource_imp.dart';
import 'package:leitor_qr_code/data/repositories/delete_history_repository_imp.dart';
import 'package:leitor_qr_code/data/repositories/get_history_repository_imp.dart';
import 'package:leitor_qr_code/domain/entities/history_entity.dart';
import 'package:leitor_qr_code/domain/usecases/delete_history/delete_history_usecase_imp.dart';
import 'package:leitor_qr_code/domain/usecases/get_history/get_history_usecase_imp.dart';
import 'package:leitor_qr_code/infra/helpers/share.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';
import 'package:leitor_qr_code/ui/widgets/screen_background.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  BannerAd? _footerBanner;

  Future<void> _copyToClipboard({required String text}) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: const EdgeInsets.all(5),
          backgroundColor: customBlack,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.copied),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Text('Ok'),
              )
            ],
          ),
        ),
      );
    }
  }

  Future<void> _deleteHistory({required int id}) async {
    final deleteHistoryUseCaseImp = DeleteHistoryUseCaseImp(
      DeleteHistoryRepositoryImp(
        DeleteHistoryCacheDataSourceImp(),
      ),
    );

    bool result = await deleteHistoryUseCaseImp.call(id: id);

    if (result) _getHistory();

    setState(() {});
  }

  void _shareText({String text = ''}) {
    ShareHelper shareHelper = ShareHelper();
    shareHelper.text(text: text);
  }

  Widget _historyItem({
    required int id,
    required String title,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(date, style: const TextStyle(fontSize: 14))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => _deleteHistory(id: id),
                icon: const Icon(Icons.delete_outline),
                splashRadius: 1,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () => _copyToClipboard(text: title),
                icon: const Icon(Icons.copy),
                splashRadius: 1,
                visualDensity: VisualDensity.compact,
              ),
              IconButton(
                onPressed: () => _shareText(text: title),
                icon: const Icon(Icons.share),
                splashRadius: 1,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<List<HistoryEntity>> _getHistory() async {
    await Future.delayed(const Duration(seconds: 1));

    final GetHistoryUseCaseImp getHistoryUseCaseImp = GetHistoryUseCaseImp(
      GetHistoryRepositoryImp(
        GetHistoryCacheDataSourceImp(),
      ),
    );

    List<HistoryEntity> result = await getHistoryUseCaseImp.call();

    return result;
  }

  FutureBuilder<List<HistoryEntity>> _mountList() {
    return FutureBuilder(
      future: _getHistory(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<HistoryEntity>> snapshot,
      ) {
        List<Widget> children;

        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            children = [
              const SizedBox(height: 10),
              const Icon(Icons.priority_high_outlined),
              Text(
                AppLocalizations.of(context).noResults,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
            ];
          } else {
            children = [
              ...snapshot.data!
                  .map((item) => _historyItem(
                        title: item.name,
                        id: item.id ?? 0,
                        date: item.getDateFormated(),
                      ))
                  .toList(),
            ];
          }
        } else if (snapshot.hasError) {
          children = [
            const Icon(Icons.error_outline, color: Colors.red),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            ),
          ];
        } else {
          children = [
            Container(
              margin: const EdgeInsets.all(10),
              width: 30,
              height: 30,
              child: const CircularProgressIndicator(color: customBlack),
            ),
          ];
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: children,
        );
      },
    );
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
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      appBarTitle: AppLocalizations.of(context).history,
      onRefresh: () async => await _getHistory(),
      appBarActions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/scan_code');
          },
          icon: const Icon(Icons.qr_code_scanner_outlined),
          color: customWhite,
        ),
      ],
      children: [_mountList()],
    );
  }
}
