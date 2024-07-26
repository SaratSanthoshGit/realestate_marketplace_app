import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/screens/home/vm_home.dart';
import 'package:realestate_marketplace_app/screens/login/login_screen.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/utils/manager/toast_manager.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../model/place_model.dart';
import '../screens/home/home_detail_view.dart';
import '../screens/login/vm_login.dart';
import '../screens/your_places/vm_new_place.dart';
import '../utils/manager/color_manager.dart';
import '../utils/manager/font_manager.dart';
import '../utils/resizer/fetch_pixels.dart';

String formatPrice(double number) {
  if (number >= 1000000000) {
    // Billion
    double billion = number / 1000000000;
    return '\$${billion.toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    // Million
    double million = number / 1000000;
    return '\$${million.toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    // Thousand
    double thousand = number / 1000;
    return '\$${thousand.toStringAsFixed(1)}K';
  } else {
    return '\$${number.toStringAsFixed(2)}';
  }
}

class HomeCard extends StatefulWidget {
  final bool isDetailedList;
  final bool isRentList;
  final bool isMyPlaceList;
  final bool isManagePlaceList;
  final double? distanceFromCL;
  final Function()? onTap;
  final PlaceModel? placeData;
  final bool isLiked;
  final bool isNeedLike;

  const HomeCard({
    super.key,
    this.isDetailedList = false,
    this.isRentList = false,
    this.isMyPlaceList = false,
    this.isManagePlaceList = false,
    this.onTap,
    this.placeData,
    this.distanceFromCL,
    this.isLiked = false,
    this.isNeedLike = true,
  });

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  Widget getIconText(IconData iData, String text) {
    return Row(
      children: [
        Icon(
          iData,
          size: widget.isDetailedList ? 18 : 16,
          color: green,
        ),
        hSpace(3),
        getCustomFont(text, widget.isDetailedList ? 13 : 11, darkGrey, 1),
      ],
    );
  }

  String formatDistance(double meters) {
    if (meters == 0) {
      return "0 m";
    } else if (meters < 1000) {
      return '${meters.toStringAsFixed(1)} m';
    } else {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)} km';
    }
  }

  RxBool isLiked = RxBool(false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isLiked) {
      isLiked.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vmLoginData = Get.find<VMLogin>();
    final data = Get.find<VMNewPlace>();
    final vmHome = Get.find<VMHome>();

    return GestureDetector(
      onTap: () {
        if (widget.onTap == null) {
          Get.to(() => HomeDetailView(
                isManagePlaceList: widget.isManagePlaceList,
                isMyPlace: widget.isMyPlaceList,
                placeData: widget.placeData,
                isLiked: isLiked.value,
              ));
        } else {
          widget.onTap!();
        }
      },
      child: Container(
        width: widget.isDetailedList
            ? double.infinity
            : FetchPixels.getPixelWidth(210),
        height: widget.isDetailedList
            ? FetchPixels.getPixelHeight(widget.isMyPlaceList ? 220 : 240)
            : double.infinity,
        margin: widget.isDetailedList ? null : const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Container(
                    height: FetchPixels.getPixelHeight(
                        widget.isDetailedList ? 125 : 110),
                    color: grey,
                    child: Image(
                      image: NetworkImage(
                        widget.placeData?.imagesUrl!.first ??
                            "https://via.placeholder.com/400x500",
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (widget.isMyPlaceList)
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton<int>(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 2,
                            onTap: () {
                              if (widget.placeData?.rejectedReason != null ||
                                  (widget.placeData?.isApproved ?? false)) {
                                data.deletePlace(widget.placeData?.placeId);
                              } else {
                                ToastManager.shared.show(
                                    "You can't delete the place when it's under review!");
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.redAccent,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                getCustomFont(
                                  "Delete",
                                  16,
                                  Colors.redAccent,
                                  1,
                                )
                              ],
                            ),
                          ),
                        ],
                        icon: const CircleAvatar(
                          backgroundColor: white,
                          child: Icon(
                            Icons.more_vert_rounded,
                            size: 20,
                            color: darkGrey,
                          ),
                        ),
                        elevation: 1,
                      ),
                    ),
                  if (!widget.isMyPlaceList &&
                      !widget.isManagePlaceList &&
                      widget.isNeedLike)
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: GestureDetector(
                          onTap: () {
                            if (vmLoginData.isLoggedIn.value) {
                              isLiked.value = !isLiked.value;
                              if (isLiked.value) {
                                vmHome.addToFavorites(widget.placeData?.placeId,
                                    widget.placeData?.userId);
                              } else {
                                vmHome.removeFromFavorites(
                                    widget.placeData?.placeId,
                                    widget.placeData?.userId);
                              }
                            } else {
                              openSignInAlert();
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: white,
                            radius: FetchPixels.getPixelWidth(13),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Obx(
                                () => Image(
                                  image: AssetImage(
                                    "heart".png,
                                  ),
                                  color: isLiked.value ? darkBlue : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (widget.distanceFromCL != null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelWidth(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: getCustomFont(
                              "In ${formatDistance(widget.distanceFromCL!)}",
                              12,
                              darkGrey,
                              1,
                              fontWeight: semiBold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            vSpace(10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: FetchPixels.getPixelWidth(
                        widget.isDetailedList ? 0 : 17.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: getCustomFont(
                            widget.placeData?.name ?? "Marina Ca, Nu",
                            widget.isDetailedList ? 17.5 : 15,
                            Colors.black,
                            1,
                            fontWeight: semiBold,
                          ),
                        ),
                        hSpace(5),
                       
                        if (widget.isMyPlaceList)
                          GestureDetector(
                            onTap: () {
                              if (widget.placeData?.rejectedReason != null) {
                                data.showAlert(
                                    context, widget.placeData?.rejectedReason);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.placeData?.rejectedReason != null
                                    ? Colors.redAccent
                                    : widget.placeData?.isApproved == true
                                        ? green
                                        : darkGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: getPaddingWidget(
                                const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                child: getCustomFont(
                                  widget.placeData?.rejectedReason != null
                                      ? "Rejected"
                                      : widget.placeData?.isApproved ?? false
                                          ? "Active"
                                          : "In Review",
                                  15,
                                  Colors.white,
                                  1,
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                    vSpace(2),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: widget.isDetailedList ? 22 : 20,
                          color: grey,
                        ),
                        hSpace(3),
                        Expanded(
                          child: getCustomFont(
                            widget.placeData?.address ?? "New York, NY 100",
                            widget.isDetailedList ? 14 : 12,
                            darkGrey,
                            1,
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                    vSpace(3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getIconText(Icons.bed_rounded,
                            "${widget.placeData?.beds ?? 0} ${widget.isDetailedList ? "Beds" : "Bds"}"),
                        getIconText(Icons.bathroom_outlined,
                            "${widget.placeData?.bath ?? 0} ${widget.isDetailedList ? "Bathrooms" : "Bath"}"),
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: getIconText(Icons.width_wide_outlined,
                              "${widget.placeData?.sqft ?? 0} sqft"),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (!widget.isMyPlaceList)
                      Row(
                        children: [
                          Expanded(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(widget.placeData?.userId)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                            DocumentSnapshot<
                                                Map<String, dynamic>>>
                                        snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  } else if (snapshot.hasData) {
                                    return Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: snapshot.data!
                                                      .data()?["photo_url"] ==
                                                  null
                                              ? null
                                              : NetworkImage(
                                                  snapshot.data!
                                                      .data()!["photo_url"]
                                                      .toString(),
                                                ),
                                          radius:
                                              widget.isDetailedList ? 11 : 10,
                                          backgroundColor: grey,
                                          child: snapshot.data!
                                                      .data()?["photo_url"] !=
                                                  null
                                              ? null
                                              : Image(
                                                  image:
                                                      AssetImage("profile".png),
                                                  color: Colors.white,
                                                ),
                                        ),
                                        hSpace(7),
                                        getCustomFont(
                                          snapshot.data!
                                                  .data()?["username"]
                                                  .toString()
                                                  .capitalize ??
                                              "Amanda Simon",
                                          widget.isDetailedList ? 13 : 12,
                                          Colors.black,
                                          1,
                                          fontWeight: bold,
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          if (widget.isDetailedList)
                            Row(
                              children: [
                                getCustomFont(
                                  "\$ ${formatPrice(double.parse(widget.placeData!.price!))}",
                                  15,
                                  Colors.black,
                                  1,
                                  fontWeight: extraBold,
                                ),
                                if (widget.isRentList)
                                  if (!(widget.placeData?.isForSale ?? true))
                                    getCustomFont(
                                      " /month",
                                      13,
                                      Colors.black,
                                      1,
                                      fontWeight: regular,
                                    ),
                              ],
                            )
                        ],
                      ),
                    vSpace(4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
