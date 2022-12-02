// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:leitor_qr_code/ui/global_styles.dart';

class CustomModal {
  Future<void> show({
    required BuildContext context,
    required List<Widget> children,
    String title = '',
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: customBlack,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      splashRadius: 20,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              ...children,
            ],
          ),
        );
      },
    );
  }
}
