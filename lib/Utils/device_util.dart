import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceUtil {
  static String get _getDeviceType {
    final data = MediaQuery.of(Get.context!);
    return data.size.shortestSide < 550 ? 'phone' : 'tablet';
  }

  static bool get isTablet {
    return _getDeviceType == 'tablet';
  }
}
