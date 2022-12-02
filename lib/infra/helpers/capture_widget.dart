// Dart imports:
import 'dart:io';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class CaptureWidget {
  Future<String> capturePng({
    required GlobalKey key,
    String fileName = 'qr-code',
  }) async {
    try {
      RenderRepaintBoundary? boundary =
          key.currentContext?.findRenderObject() as RenderRepaintBoundary;

      var image = await boundary.toImage();

      ByteData? byteData = await image.toByteData(
        format: ImageByteFormat.png,
      );

      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (fileName.isNotEmpty) {
        fileName = fileName.replaceAll(' ', '-');
      } else {
        fileName = DateTime.now().toString();
      }

      File imgFile = File('/storage/emulated/0/Download/$fileName.png');

      imgFile.writeAsBytes(pngBytes!);

      return imgFile.path;
    } catch (error) {
      return '';
    }
  }
}
