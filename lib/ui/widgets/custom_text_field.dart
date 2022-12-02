// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:leitor_qr_code/ui/global_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;

  const CustomTextField({this.controller, this.hintText = '', Key? key})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: widget.controller,
        onChanged: (text) => setState(() {}),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(decoration: TextDecoration.none),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: customBlack),
          ),
        ),
      ),
    );
  }
}
