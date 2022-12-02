// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:barcode_widget/barcode_widget.dart';

// Project imports:
import 'package:leitor_qr_code/ui/global_styles.dart';

class QRCodeWidget extends StatefulWidget {
  final String data;

  const QRCodeWidget({required this.data, Key? key}) : super(key: key);
  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: customWhite,
      child: BarcodeWidget(
        data: widget.data,
        barcode: Barcode.qrCode(),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
