import 'package:share_plus/share_plus.dart';

class ShareHelper {
  void text({required String text}) {
    Share.share(text);
  }
}
