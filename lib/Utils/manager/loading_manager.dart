import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart';

class LoadingManager {
  static final shared = LoadingManager();
  OverlayEntry? entry;

  OverlayEntry loadingOverlayEntry() {
    return OverlayEntry(builder: (BuildContext context) {
      return IgnorePointer(
        ignoring: true,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(
              color: white,
            ),
          ),
        ),
      );
    });
  }

  showLoading() async {
    await Future.delayed(Duration.zero);
    final state = Overlay.of(Get.overlayContext!);
    if (entry == null) {
      entry = loadingOverlayEntry();
      state.insert(entry!);
    }
  }

  hideLoading() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
  }
}

const loading = Center(child: CircularProgressIndicator());

Widget getErrorMessage() {
  return const Center(child: Text("Something went wrong!"));
}
