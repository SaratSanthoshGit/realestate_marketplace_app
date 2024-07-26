import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:realestate_marketplace_app/utils/manager/font_manager.dart';

import 'color_manager.dart';

class ToastManager {
  static final shared = ToastManager();
  OverlayEntry? entry;
  final debounce = Debouncer(delay: const Duration(seconds: 2));

  show(String msg) {
    final state = Overlay.of(Get.overlayContext!);
    removeIfNeeded();
    entry = OverlayEntry(
        builder: (context) => ToastView(
              msg: msg,
            ));
    state.insert(entry!);
    handleTimer();
  }

  handleTimer() {
    debounce.call(() {
      removeIfNeeded();
    });
  }

  removeIfNeeded() {
    if (entry == null) return;
    entry?.remove();
    entry = null;
  }
}

class ToastView extends StatelessWidget {
  const ToastView({super.key, required this.msg});

  final String msg;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Container(
                constraints: const BoxConstraints(minWidth: 250),
                decoration: BoxDecoration(
                  color: darkBlue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
