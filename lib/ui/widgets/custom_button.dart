import 'package:flutter/material.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final void Function()? onPressed;
  final IconData? iconName;

  const CustomButton({
    required this.label,
    required this.onPressed,
    this.iconName,
    Key? key,
  }) : super(key: key);
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(6),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(customBlack),
        ),
        onPressed: widget.onPressed,
        child: Row(
          children: [
            Text(widget.label),
            if (widget.iconName != null) Icon(widget.iconName)
          ],
        ),
      ),
    );
  }
}
