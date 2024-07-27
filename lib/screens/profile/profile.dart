import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/controller/route_controller.dart';
import 'package:realestate_marketplace_app/screens/profile/manage_places.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart' as c_ext;
import 'package:realestate_marketplace_app/utils/manager/loading_manager.dart' as loading_mgr;
import '../../utils/manager/color_manager.dart';
import '../../utils/manager/font_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../../widget/appbar/common_appbar.dart';
import '../../widget/buttons/secondary_button.dart';
import '../../widget/widget_utils.dart';
import '../login/vm_login.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  Widget getTag(title, value) {
    return Expanded(
      child: Column(
        children: [
          getCustomFont(
            title,
            12,
            darkGrey,
            1,
            fontWeight: medium,
          ),
          getCustomFont(
            value,
            18,
            darkGrey,
            1,
            fontWeight: bold,
          ),
        ],
      ),
    );
  }

  final RxBool isEditMode = RxBool(false);

  String formatNumber(int number) {
    if (number >= 1e27) {
      return '${(number / 1e27).toStringAsFixed(2)}D';
    } else if (number >= 1e24) {
      return '${(number / 1e24).toStringAsFixed(2)}N';
    } else if (number >= 1e21) {
      return '${(number / 1e21).toStringAsFixed(2)}O';
    } else if (number >= 1e18) {
      return '${(number / 1e18).toStringAsFixed(2)}SS';
    } else if (number >= 1e15) {
      return '${(number / 1e15).toStringAsFixed(2)}S';
    } else if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(2)}QQ';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}Q';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return number.toString();
    }
  }

 @override
Widget build(BuildContext context) {
  final data = Get.find<VMLogin>();
  data.selectedImages.value = null;
  User? userData = FirebaseAuth.instance.currentUser;
  double radius = FetchPixels.getPixelWidth(55);
  return PopScope(
    canPop: false,
    onPopInvoked: (didPop) {
      if (didPop) return;
      RouteController.to.currentPos.value = 0;
    },
    child: Scaffold(
      appBar: CObx(
        () => CommonAppBar(
          isProfile: !isEditMode.value,
          isEditModeOn: isEditMode.value,
          onEditClick: () {
            isEditMode.value = true;
          },
          onDoneClick: () {
            data.updateProfile(() => isEditMode.value = false);
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(userData?.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loading_mgr.loading;
                    } else if (snapshot.hasData) {
                      Map<String, dynamic>? userFireData =
                          snapshot.data!.data();
                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: FetchPixels.getPixelHeight(8),
                            horizontal: FetchPixels.getPixelHeight(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCustomFont(
                                "Profile",
                                20,
                                Colors.black,
                                1,
                                fontWeight: bold,
                              ),
                              vSpace(15),
                              vSpace(radius),
                              Stack(
                                alignment: Alignment.topCenter,
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: FetchPixels.getPixelHeight(200),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 1,
                                        color: grey,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        vSpace(radius),
                                        getCustomFont(
                                          userData?.displayName
                                                  .toString()
                                                  .capitalize ?? "",
                                          18,
                                          Colors.black,
                                          1,
                                          fontWeight: bold,
                                        ),
                                        vSpace(5),
                                        getCustomFont(
                                          userData?.email ?? "",
                                          14,
                                          darkGrey,
                                          1,
                                          fontWeight: bold,
                                        ),
                                        const Spacer(),
                                        getPaddingWidget(
                                          EdgeInsets.symmetric(
                                            horizontal:
                                                FetchPixels.getPixelWidth(10),
                                          ),
                                          child: Row(
                                            children: [
                                              getTag(
                                                  "Your Places",
                                                  formatNumber(
                                                      userFireData!["places"])),
                                              getTag(
                                                  "Views",
                                                  formatNumber(
                                                      userFireData["views"])),
                                              getTag(
                                                  "Likes",
                                                  formatNumber(
                                                      userFireData["likes"])),
                                            ],
                                          ),
                                        ),
                                        vSpace(20),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: -radius,
                                    child: Obx(
                                      () => Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          CircleAvatar(
                                            radius: radius,
                                            backgroundColor: grey,
                                            backgroundImage: (data
                                                        .selectedImages.value !=
                                                    null
                                                ? FileImage(
                                                    data.selectedImages.value!)
                                                : userData?.photoURL == null
                                                    ? null
                                                    : NetworkImage(
                                                        userData?.photoURL ??
                                                            "",
                                                      )) as ImageProvider<
                                                Object>?,
                                            child: data.selectedImages.value !=
                                                    null
                                                ? null
                                                : userData?.photoURL == null
                                                    ? Image(
                                                        image: AssetImage(
                                                            "profile_dummy"
                                                                .png),
                                                      )
                                                    : null,
                                          ),
                                          if (isEditMode.value)
                                            IconButton(
                                              onPressed: () {
                                                data.pickImages();
                                              },
                                              icon: const CircleAvatar(
                                                backgroundColor: darkGrey,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              vSpace(15),
                              if (FirebaseAuth.instance.currentUser?.email ==
                                  "admin@gmail.com")
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const ManagePlaces());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          width: .5, color: darkGrey),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: getCustomFont(
                                              "Manage Places",
                                              15,
                                              Colors.black,
                                              1,
                                              fontWeight: semiBold,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.double_arrow_rounded,
                                            color: darkGrey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return c_ext.getErrorMessage("An error occurred");
                    }
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: FetchPixels.getPixelHeight(8),
                horizontal: FetchPixels.getPixelHeight(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      isFromProfile: true,
                      padding: EdgeInsets.symmetric(
                        vertical: FetchPixels.getPixelHeight(10),
                      ),
                      color: darkGrey,
                      onTap: () {
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
    );
  }
}

class CObx extends Obx implements PreferredSizeWidget {
  static final _appBar = AppBar();

  const CObx(super.builder, {super.key});

  @override
  Size get preferredSize => _appBar.preferredSize;
}