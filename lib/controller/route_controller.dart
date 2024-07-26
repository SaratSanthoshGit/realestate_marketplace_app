import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class RouteController extends GetxController {
  static RouteController to = Get.find();

  final zoomDrawerController = ZoomDrawerController();

  RxInt currentPos = RxInt(0);

  void toggleDrawer() {
    zoomDrawerController.open!();
    // update();
  }
}
