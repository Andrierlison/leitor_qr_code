// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:barcode_widget/barcode_widget.dart';

// Project imports:
import 'package:leitor_qr_code/ui/global_styles.dart';

class BarCodeWidget extends StatefulWidget {
  final String data;

  const BarCodeWidget({required this.data, Key? key}) : super(key: key);
  @override
  State<BarCodeWidget> createState() => _BarCodeWidgetState();
}

class _BarCodeWidgetState extends State<BarCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: customWhite,
      child: BarcodeWidget(
        data: widget.data,
        barcode: Barcode.code128(),
        padding: const EdgeInsets.all(10),
      ),
    );
  }
}
