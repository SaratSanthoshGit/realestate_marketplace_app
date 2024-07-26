import 'package:get/get.dart';
import 'package:realestate_marketplace_app/controller/route_controller.dart';
import 'package:realestate_marketplace_app/screens/home/vm_home.dart';
import 'package:realestate_marketplace_app/screens/your_places/vm_new_place.dart';

import '../screens/login/vm_login.dart';

class Binder extends Bindings {
  @override
  void dependencies() {
    Get.put(RouteController());

    Get.lazyPut(() => VMLogin(), fenix: true);
    Get.lazyPut(() => VMNewPlace(), fenix: true);
    Get.lazyPut(() => VMHome(), fenix: true);
  }
}
