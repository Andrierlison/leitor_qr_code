// Package imports:
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  void text({required String text}) {
    Share.share(text);
  }

  void files({required List<String> files}) {
    try {
      List<XFile> toShare = files.map((item) => XFile(item)).toList();
      Share.shareXFiles(toShare);
    } catch (error) {
      throw const FormatException('Error');
    }
  }
}
