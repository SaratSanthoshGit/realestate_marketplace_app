import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/controller/route_controller.dart';
import 'package:realestate_marketplace_app/screens/login/login_screen.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart' as cm;
import 'package:realestate_marketplace_app/utils/resizer/fetch_pixels.dart';
import 'package:realestate_marketplace_app/widget/appbar/first_appbar.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';
// import '../../Utils/manager/color_manager.dart';
import '../../widget/buttons/secondary_button.dart';
import '../login/vm_login.dart';

class CDrawer extends StatelessWidget {
  const CDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Get.find<VMLogin>();

    return Scaffold(
      backgroundColor: cm.darkBlue,
      body: SafeArea(
        child: getPaddingWidget(
          const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomBack(
                    onBack: () {
                      RouteController.to.zoomDrawerController.close!();
                    },
                    color: Colors.white,
                  ),
                ],
              ),
              const Spacer(),
              Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DrawerTile<String>(
                      "home",
                      "Home",
                      isActive: RouteController.to.currentPos.value == 0,
                      onTap: () {
                        RouteController.to.zoomDrawerController.close!();
                        RouteController.to.currentPos.value = 0;
                      },
                    ),
                    DrawerTile<IconData>(
                      Icons.add_box_rounded,
                      "Your Places",
                      isActive: RouteController.to.currentPos.value == 1,
                      onTap: () {
                        RouteController.to.zoomDrawerController.close!();
                        if (data.isLoggedIn.value) {
                          RouteController.to.currentPos.value = 1;
                        } else {
                          openSignInAlert();
                        }
                      },
                    ),
                    DrawerTile<String>(
                      "profile",
                      "Profile",
                      isActive: RouteController.to.currentPos.value == 2,
                      onTap: () {
                        RouteController.to.zoomDrawerController.close!();
                        if (data.isLoggedIn.value) {
                          RouteController.to.currentPos.value = 2;
                        } else {
                          openSignInAlert();
                        }
                      },
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Obx(
                () => !data.isLoggedIn.value
                    ? Container()
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 3,
                            ),
                            child: SecondaryButton(
                              onTap: () {
                                RouteController
                                    .to.zoomDrawerController.close!();
                                data.logout();
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile<T> extends StatelessWidget {
  final T icon;
  final String title;
  final bool isActive;
  final Function()? onTap;

  const DrawerTile(this.icon, this.title, {super.key, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return getPaddingWidget(
      const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 3,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: !isActive ? null : Colors.white.withOpacity(.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if (icon == "heart") hSpace(3),
                      icon.runtimeType == String
                          ? ImageIcon(
                              AssetImage(icon.toString().png),
                              color: Colors.white,
                              size: FetchPixels.getPixelHeight(
                                icon == "heart" ? 17 : 20,
                              ),
                            )
                          : Icon(
                              icon as IconData,
                              color: Colors.white,
                              size: FetchPixels.getPixelHeight(22),
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                      hSpace(20),
                      getCustomFont(title, 18, Colors.white, 1),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      )
                    ],
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
