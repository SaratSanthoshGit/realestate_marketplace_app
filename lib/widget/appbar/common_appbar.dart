import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';

import '../../screens/login/login_screen.dart';
import '../../screens/login/vm_login.dart';
import '../../screens/your_places/add_new_place.dart';
import '../../screens/your_places/vm_new_place.dart';
import '../../utils/manager/color_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final bool isMyPlace;
  final bool isProfile;
  final bool isEditModeOn;
  final Function()? onEditClick;
  final Function()? onDoneClick;

  CommonAppBar({
    super.key,
    this.isHome = false,
    this.isMyPlace = false,
    this.isProfile = false,
    this.isEditModeOn = false,
    this.onEditClick,
    this.onDoneClick,
  });

  final data = Get.find<VMNewPlace>();

  @override
  Widget build(BuildContext context) {
    final vmLoginData = Get.find<VMLogin>();

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          RouteController.to.toggleDrawer();
        },
        icon: ImageIcon(
          AssetImage("menu".png),
          size: 37.5,
          color: Colors.black,
        ),
      ),
      actions: [
        if (isHome)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                if (vmLoginData.isLoggedIn.value) {
                  RouteController.to.currentPos.value = 3;
                } else {
                  openSignInAlert();
                }
              },
              icon: ImageIcon(
                AssetImage("heart".png),
                size: 24,
                // width: FetchPixels.getPixelWidth(20),
                // height: FetchPixels.getPixelHeight(20),
                color: darkBlue,
                // scale: FetchPixels.getScale(),
              ),
            ),
          ),
        if (isMyPlace)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: darkBlue,
              child: IconButton(
                onPressed: () {
                  Get.to(() => AddNewPlace());
                  data.determinePosition();
                },
                icon: Icon(
                  Icons.add_box_rounded,
                  size: FetchPixels.getPixelWidth(20),
                  color: white,
                ),
              ),
            ),
          ),
        if (isProfile)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: darkBlue,
              child: IconButton(
                onPressed: onEditClick,
                icon: Icon(
                  Icons.edit,
                  size: FetchPixels.getPixelWidth(20),
                  color: white,
                ),
              ),
            ),
          ),
        if (isEditModeOn)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: darkBlue,
              child: IconButton(
                onPressed: onDoneClick,
                icon: Icon(
                  Icons.done,
                  size: FetchPixels.getPixelWidth(20),
                  color: white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static final _appBar = AppBar();

  @override
  Size get preferredSize => _appBar.preferredSize;
}
