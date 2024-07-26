import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/screens/home/search_screen.dart';
import 'package:realestate_marketplace_app/screens/home/vm_home.dart';
import 'package:realestate_marketplace_app/utils/manager/font_manager.dart';
import 'package:realestate_marketplace_app/utils/resizer/fetch_pixels.dart';
import 'package:realestate_marketplace_app/widget/search.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../../model/place_model.dart';
import '../../utils/manager/loading_manager.dart';
import '../../widget/appbar/common_appbar.dart';
import '../../widget/category_chip.dart';
import '../../widget/home_card.dart';
import '../login/vm_login.dart';
import 'home_list.dart';

class Home extends StatelessWidget {
  Home({super.key});

  VMHome vmHome = VMHome.to;
  RxnInt selectedCategory = RxnInt();

  Widget getTitle(String title,
      {bool isRent = false, required List<PlaceModel> place}) {
    return Row(
      children: [
        Expanded(
          child: getCustomFont(
            title,
            20,
            Colors.black,
            1,
            fontWeight: bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => HomeList(title, isRent, place));
          },
          child: getCustomFont(
            "View all",
            12,
            Colors.black,
            1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    RouteController routeController = Get.find();
    final vmLoginData = Get.find<VMLogin>();
    return Scaffold(
      appBar: CommonAppBar(isHome: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: FetchPixels.getPixelHeight(8),
            horizontal: FetchPixels.getPixelHeight(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => getCustomFont(
                  "Looking for your own cave? Lets get started, ${vmLoginData.loggedInUser.value != null ? "${vmLoginData.loggedInUser.value?.displayName?.capitalizeFirst ?? "There"} !" : "There !"}",
                  20,
                  Colors.black,
                  1,
                  fontWeight: bold,
                ),
              ),
              vSpace(15),
              GestureDetector(
                onTap: () {
                  Get.to(() => SearchScreen());
                },
                child: Search(enable: false),
              ),
              vSpace(12.5),
              Transform.translate(
                offset: const Offset(-8, 0),
                child: SizedBox(
                  height: FetchPixels.getPixelHeight(112.5),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: vmHome.category.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(
                        () => CategoryChip(
                          vmHome.category[index],
                          index == selectedCategory.value,
                          () {
                            if (selectedCategory.value == index) {
                              selectedCategory.value = null;
                            } else {
                              selectedCategory.value = index;
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              vSpace(10),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loading;
                    } else if (snapshot.hasData) {
                      Map<String, dynamic>? userFireData =
                          snapshot.data!.data();
                      vmHome.favorites.value = userFireData?["favorites"] ?? [];

                      return Container();
                    } else {
                      return Container();
                    }
                  }),
              Obx(
                () => StreamBuilder(
                  stream: selectedCategory.value == null
                      ? FirebaseFirestore.instance
                          .collection("places")
                          .where("isApproved", isEqualTo: true)
                          .where("isForSale", isEqualTo: true)
                          .orderBy('created_at', descending: true)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("places")
                          .where("isApproved", isEqualTo: true)
                          .where("isForSale", isEqualTo: true)
                          .where("category_id",
                              isEqualTo: (selectedCategory.value! + 1))
                          .orderBy('created_at', descending: true)
                          .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    // List channelUsers =
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasData) {
                      List<PlaceModel> list = snapshot.data!.docs.map(
                        (e) {
                          return PlaceModel.fromJson(
                            e.data(),
                          );
                        },
                      ).toList();
                      return list.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                getTitle("Buy a home", place: list),
                                vSpace(15),
                                SizedBox(
                                  height: FetchPixels.getPixelHeight(220),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: list.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return HomeCard(
                                        placeData: list[index],
                                        isLiked: vmHome.favorites
                                            .contains(list[index].placeId),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                    } else {
                      print(snapshot.error);
                      return Container();
                    }
                  },
                ),
              ),
              Obx(
                () => StreamBuilder(
                  stream: selectedCategory.value == null
                      ? FirebaseFirestore.instance
                          .collection("places")
                          .where("isApproved", isEqualTo: true)
                          .where("isForSale", isEqualTo: false)
                          .orderBy('created_at', descending: true)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection("places")
                          .where("isApproved", isEqualTo: true)
                          .where("isForSale", isEqualTo: false)
                          .where("category_id",
                              isEqualTo: (selectedCategory.value! + 1))
                          .orderBy('created_at', descending: true)
                          .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    // List channelUsers =
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasData) {
                      List<PlaceModel> list = snapshot.data!.docs.map(
                        (e) {
                          return PlaceModel.fromJson(
                            e.data(),
                          );
                        },
                      ).toList();
                      return list.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                vSpace(25),
                                getTitle(
                                  "Rent a home",
                                  isRent: true,
                                  place: list,
                                ),
                                vSpace(15),
                                SizedBox(
                                  height: FetchPixels.getPixelHeight(220),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: list.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return HomeCard(
                                        placeData: list[index],
                                        isLiked: vmHome.favorites
                                            .contains(list[index].placeId),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                    } else {
                      print(snapshot.error);
                      return Container();
                    }
                  },
                ),
              ),
              vSpace(25),
            ],
          ),
        ),
      ),
    );
  }
}
