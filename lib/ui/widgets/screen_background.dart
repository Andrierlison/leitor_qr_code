import 'package:flutter/material.dart';
import 'package:leitor_qr_code/ui/global_styles.dart';

class ScreenBackground extends StatefulWidget {
  final String appBarTitle;
  final List<Widget> children;
  final List<Widget> appBarActions;
  final Future<void> Function()? onRefresh;

  const ScreenBackground({
    required this.children,
    this.onRefresh,
    this.appBarTitle = '',
    this.appBarActions = const [],
    super.key,
  });

  @override
  State<ScreenBackground> createState() => _ScreenBackgroundState();
}

class _ScreenBackgroundState extends State<ScreenBackground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarTitle.isEmpty
          ? null
          : AppBar(
              title: Text(widget.appBarTitle),
              actions: widget.appBarActions,
            ),
      body: SafeArea(
        child: RefreshIndicator(
          color: customBlack,
          notificationPredicate:
              widget.onRefresh != null ? (_) => true : (_) => false,
          onRefresh: () async {
            if (widget.onRefresh != null) await widget.onRefresh!();
          },
          child: Container(
            color: customWhite,
            child: ListView(
              children: widget.children,
            ),
          ),
        ),
      ),
    );
  }
}
