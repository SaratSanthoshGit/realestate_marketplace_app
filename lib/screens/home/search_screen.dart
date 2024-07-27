import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart';
import 'package:realestate_marketplace_app/utils/manager/font_manager.dart';

import '../../model/place_model.dart';
import '../../utils/manager/loading_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../../widget/home_card.dart';
import '../../widget/search.dart';
import '../../widget/widget_utils.dart';
import '../your_places/vm_new_place.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final data = Get.find<VMNewPlace>();
  final TextEditingController search = TextEditingController();
  final Logger _logger = Logger('SearchScreen');

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371;
    final double dLat = degreesToRadians(lat2 - lat1);
    final double dLon = degreesToRadians(lon2 - lon1);
    final double a = pow(sin(dLat / 2), 2) +
        cos(degreesToRadians(lat1)) *
            cos(degreesToRadians(lat2)) *
            pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadius * c;
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    RxBool selectedTab = RxBool(true);
    RxBool locationFilterOn = RxBool(false);
    RxList<PlaceModel> rawList = RxList([]);
    RxList<PlaceModel> filteredList = RxList([]);

    getSaleOrRentList(bool isForSale) {
      return rawList.where((item) => item.isForSale == isForSale).toList();
    }

    filterBasedOnDistance({bool isNeedGetLocation = false}) async {
      if (isNeedGetLocation) {
        await data.determinePosition();
      }
      if (data.currentLocation != null) {
        double currentLat = data.currentLocation!.latitude;
        double currentLong = data.currentLocation!.longitude;

        filteredList.sort(
          (a, b) => calculateDistance(
            a.latitude!,
            a.longitude!,
            currentLat,
            currentLong,
          ).compareTo(
            calculateDistance(
              b.latitude!,
              b.longitude!,
              currentLat,
              currentLong,
            ),
          ),
        );
        filteredList.refresh();
      }
    }

    onSearch(value) {
      filteredList.value = rawList
          .where((item) =>
              item.name!
                  .toLowerCase()
                  .contains(value.toString().toLowerCase()) &&
              item.isForSale == selectedTab.value)
          .toList();
      if (locationFilterOn.value) {
        filterBasedOnDistance();
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: FetchPixels.getPixelHeight(8),
            horizontal: FetchPixels.getPixelHeight(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(10),
              Row(
                children: [
                  Expanded(
                    child: Search(
                      enable: true,
                      controller: search,
                      onChange: onSearch,
                    ),
                  ),
                  hSpace(10),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: getCustomFont(
                      "Cancel",
                      15,
                      darkBlue,
                      1,
                      fontWeight: medium,
                    ),
                  )
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("places")
                      .where("isApproved", isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loading;
                    } else if (snapshot.hasData) {
                      rawList.value = snapshot.data!.docs.map(
                        (e) {
                          return PlaceModel.fromJson(
                            e.data(),
                          );
                        },
                      ).toList();
                      filteredList.value = getSaleOrRentList(true);
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            vSpace(16),
                            Obx(
                              () => AnimatedToggleSwitch<bool>.size(
                                current: selectedTab.value,
                                values: const [true, false],
                                indicatorSize:
                                    const Size.fromWidth(double.infinity),
                                customIconBuilder: (context, local, global) =>
                                    Text(
                                  (local.value ? 'For Sale' : 'For Rent').tr,
                                  style: TextStyle(
                                    color: Color.lerp(
                                      Colors.black,
                                      Colors.black,
                                      local.animationValue,
                                    ),
                                    fontSize: 15,
                                  ),
                                ),
                                borderWidth: 5.0,
                                iconAnimationType: AnimationType.onSelected,
                                style: ToggleStyle(
                                  indicatorColor: white,
                                  backgroundColor: const Color(0xFFebebec),
                                  borderColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                selectedIconScale: 1.0,
                                height: 45,
                                onChanged: (b) {
                                  search.clear();
                                  onSearch("");
                                  selectedTab.value = b;
                                  filteredList.value = getSaleOrRentList(b);
                                  if (locationFilterOn.value) {
                                    filterBasedOnDistance();
                                  }
                                },
                              ),
                            ),
                            vSpace(5),
                            const Divider(
                              thickness: .5,
                              color: grey,
                            ),
                            InkWell(
                              onTap: () {
                                search.clear();
                                onSearch("");
                                locationFilterOn.value =
                                    !locationFilterOn.value;
                                if (locationFilterOn.value) {
                                  filterBasedOnDistance(
                                      isNeedGetLocation: true);
                                } else {
                                  filteredList.value =
                                      getSaleOrRentList(selectedTab.value);
                                }
                              },
                              child: Obx(
                                () => Column(
                                  children: [
                                    vSpace(5),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_rounded,
                                          color: grey,
                                        ),
                                        hSpace(10),
                                        getCustomFont(
                                          "Current Location",
                                          15,
                                          Colors.black,
                                          1,
                                          fontWeight: semiBold,
                                        ),
                                        const Spacer(),
                                        if (locationFilterOn.value)
                                          const Icon(
                                            Icons.check,
                                            color: darkBlue,
                                          ),
                                      ],
                                    ),
                                    vSpace(5),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              thickness: .5,
                              color: grey,
                            ),
                            vSpace(5),
                            Obx(
                              () => filteredList.isEmpty
                                  ? emptyView("No result found!")
                                  : ListView.builder(
                                      itemCount: filteredList.length,
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(top: 6),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return getPaddingWidget(
                                          EdgeInsets.only(
                                            bottom:
                                                FetchPixels.getPixelHeight(20),
                                          ),
                                          child: HomeCard(
                                            isDetailedList: true,
                                            placeData: filteredList[index],
                                            distanceFromCL: locationFilterOn
                                                    .value
                                                ? data.currentLocation != null
                                                    ? calculateDistance(
                                                        filteredList[index]
                                                            .latitude!,
                                                        filteredList[index]
                                                            .longitude!,
                                                        data.currentLocation!
                                                            .latitude,
                                                        data.currentLocation!
                                                            .longitude,
                                                      )
                                                    : null
                                                : null,
                                            isNeedLike: false,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      _logger.warning('Error in StreamBuilder: ${snapshot.error}');
                      return getErrorMessage();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}