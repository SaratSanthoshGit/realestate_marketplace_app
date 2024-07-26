import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/screens/dashboard/c_drawer.dart';
import 'package:realestate_marketplace_app/screens/favorites/favorites.dart';
import 'package:realestate_marketplace_app/screens/home/home.dart';
import 'package:realestate_marketplace_app/screens/profile/profile.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../../utils/manager/color_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../login/login_screen.dart';
import '../login/vm_login.dart';
import '../your_places/your_places.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  List<dynamic> bottomBarList = [
    {
      "icon": "home".png,
      "title": "Home",
    },
    Icons.add,
    {
      "icon": "profile".png,
      "title": "Profile",
    },
  ];

  @override
  Widget build(BuildContext context) {
    RouteController routeController = Get.find();
    return ZoomDrawer(
      controller: RouteController.to.zoomDrawerController,
      menuScreen: const CDrawer(),
      borderRadius: 24.0,
      showShadow: false,
      angle: 0.0,
      drawerShadowsBackgroundColor: darkBlue,
      menuBackgroundColor: darkBlue,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      mainScreen: Scaffold(
        body: Obx(
          () => routeController.currentPos.value == 0
              ? Home()
              : routeController.currentPos.value == 1
                  ? const YourPlaces()
                  : routeController.currentPos.value == 2
                      ? Profile()
                      : const Favorites(),
        ),
        bottomNavigationBar: buildBottomBar(
          FetchPixels.getPixelHeight(40),
          FetchPixels.getPixelHeight(24),
        ),
      ),
    );
  }

  Container buildBottomBar(double size, double iconSize) {
    final data = Get.find<VMLogin>();
    RouteController routeController = Get.find();
    return Container(
        height: FetchPixels.getPixelHeight(80),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 50,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Obx(
          () => Row(
              children: List.generate(bottomBarList.length, (index) {
            return Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if (index == 1 || index == 2) {
                    if (data.isLoggedIn.value) {
                      routeController.currentPos.value = index;
                    } else {
                      openSignInAlert();
                    }
                  } else {
                    routeController.currentPos.value = index;
                  }
                },
                child: Center(
                  child: Container(
                    width: index == 1 ? size : null,
                    height: index == 1 ? size : null,
                    decoration: BoxDecoration(
                      color: index == 1 ? darkBlue : Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: index == 1
                          ? Icon(
                              bottomBarList[index],
                              color: index == 1 ? Colors.white : null,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ImageIcon(
                                  AssetImage(
                                    bottomBarList[index]["icon"],
                                  ),
                                  color:
                                      routeController.currentPos.value == index
                                          ? black
                                          : grey,
                                ),
                                getCustomFont(
                                  bottomBarList[index]["title"],
                                  10,
                                  routeController.currentPos.value == index
                                      ? black
                                      : grey,
                                  1,
                                )
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            );
          })),
        ));
  }
}
