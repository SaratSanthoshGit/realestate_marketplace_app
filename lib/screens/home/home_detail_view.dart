import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:realestate_marketplace_app/screens/home/vm_home.dart';
import 'package:realestate_marketplace_app/screens/profile/pdf_viewer.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/utils/manager/font_manager.dart';
import 'package:realestate_marketplace_app/utils/manager/toast_manager.dart';
import 'package:realestate_marketplace_app/widget/appbar/first_appbar.dart';
import 'package:realestate_marketplace_app/widget/buttons/secondary_button.dart';
import 'package:realestate_marketplace_app/widget/home_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/place_model.dart';
import '../../utils/manager/color_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../../widget/buttons/primary_button.dart';
import '../../widget/widget_utils.dart';
import '../login/login_screen.dart';
import '../login/vm_login.dart';
import '../textbox/first_textbox.dart';
import '../textbox/vm_textbox.dart';
import '../your_places/vm_new_place.dart';

class HomeDetailView extends StatefulWidget {
  final bool isManagePlaceList;
  final bool isMyPlace;
  final PlaceModel? placeData;
  final bool isLiked;

  const HomeDetailView({
    super.key,
    this.isManagePlaceList = false,
    this.isMyPlace = false,
    this.placeData,
    this.isLiked = false,
  });

  @override
  State<HomeDetailView> createState() => _HomeDetailViewState();
}

class _HomeDetailViewState extends State<HomeDetailView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user?.uid != widget.placeData?.userId) {
        var userRef = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.placeData?.userId);

        DocumentSnapshot<Map<String, dynamic>> profileData =
            await userRef.get();

        userRef.update({"views": profileData.data()?["views"] + 1});
      }
    });

    if (widget.isLiked) {
      isLiked.value = true;
    }
  }

  Widget getIconText(IconData iData, String text) {
    return Row(
      children: [
        Icon(
          iData,
          size: 23,
          color: Colors.black,
        ),
        hSpace(3),
        getCustomFont(text, 13, darkGrey, 1, fontWeight: semiBold),
      ],
    );
  }

  final reason = VMTextBox(
    placeholder: '',
    keyboardType: TextInputType.multiline,
  );

  rejectSheet() {
    final data = Get.find<VMNewPlace>();

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 35, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(
                        "Enter the reason!",
                        22,
                        Colors.black,
                        1,
                        fontWeight: bold,
                      ),
                      vSpace(16),
                      FirstTextBox(
                        data: reason,
                        isNeedTopPlaceholder: false,
                        maxLines: 10,
                      ),
                      vSpace(16),
                      Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              title: "Reject",
                              // isFromProfile: true,
                              padding: EdgeInsets.symmetric(
                                vertical: FetchPixels.getPixelHeight(10),
                                horizontal: FetchPixels.getPixelWidth(17),
                              ),
                              color: Colors.redAccent,
                              onTap: () {
                                if (reason.text.isEmpty) {
                                  ToastManager.shared.show(
                                      "Please enter the reason for rejection!");
                                } else {
                                  data.rejectPlace(
                                      widget.placeData?.placeId, reason.text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.30),
      isDismissible: true,
      isScrollControlled: true,
    );
  }

  CarouselController carouselController = CarouselController();

  final RxInt _currentIndex = RxInt(0);

  RxBool isLiked = RxBool(false);

  @override
  Widget build(BuildContext context) {
    final vmLoginData = Get.find<VMLogin>();
    VMHome vmHome = VMHome.to;
    final data = Get.find<VMNewPlace>();

    EdgeInsets edgeInsets = const EdgeInsets.symmetric(horizontal: 15);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: getPaddingWidget(
              edgeInsets,
              child: Column(
                children: [
                  FirstAppBar(
                    title: "Details",
                    action: widget.isManagePlaceList || widget.isMyPlace
                        ? Container()
                        : Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (vmLoginData.isLoggedIn.value) {
                                    isLiked.value = !isLiked.value;
                                    if (isLiked.value) {
                                      vmHome.addToFavorites(
                                          widget.placeData?.placeId,
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
                                icon: Obx(
                                  () => Image.asset(
                                    "heart".png,
                                    width: FetchPixels.getPixelWidth(20),
                                    height: FetchPixels.getPixelHeight(20),
                                    color: isLiked.value ? darkBlue : null,
                                    scale: FetchPixels.getScale(),
                                  ),
                                ),
                              ),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: Icon(
                              //     Icons.ios_share_outlined,
                              //     color: darkGrey,
                              //   ),
                              // ),
                            ],
                          ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CarouselSlider(
                                carouselController: carouselController,
                                options: CarouselOptions(
                                  // height: 156,
                                  // aspectRatio: 16 / 9,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  enableInfiniteScroll: 1 == 1 ? false : true,
                                  reverse: false,
                                  autoPlay: 1 == 1 ? false : true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(seconds: 1),
                                  enlargeCenterPage: false,
                                  // enlargeFactor: 0.3,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index, reason) {
                                    _currentIndex.value = index;
                                  },
                                ),
                                items: widget.placeData?.imagesUrl
                                    ?.map((e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Container(
                                              height:
                                                  FetchPixels.getPixelHeight(
                                                      180),
                                              color: grey,
                                              child: Image(
                                                image: NetworkImage(
                                                  e ??
                                                      "https://via.placeholder.com/400x500",
                                                ),
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 6),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "gallery".png,
                                              width:
                                                  FetchPixels.getPixelWidth(19),
                                              height:
                                                  FetchPixels.getPixelHeight(
                                                      19),
                                              color: darkGrey,
                                              scale: FetchPixels.getScale(),
                                            ),
                                            hSpace(5),
                                            Obx(
                                              () => getCustomFont(
                                                "${_currentIndex.value + 1} / ${widget.placeData?.imagesUrl?.length ?? 1}",
                                                15,
                                                darkGrey,
                                                1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          vSpace(15),
                          Row(
                            children: [
                              StreamBuilder(
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
                                            radius: 18,
                                            backgroundColor: grey,
                                            backgroundImage: snapshot.data!
                                                        .data()?["photo_url"] ==
                                                    null
                                                ? null
                                                : NetworkImage(
                                                    snapshot.data!
                                                        .data()!["photo_url"]
                                                        .toString(),
                                                  ),
                                            child: snapshot.data!
                                                        .data()?["photo_url"] !=
                                                    null
                                                ? null
                                                : Image(
                                                    image: AssetImage(
                                                        "profile".png),
                                                    color: Colors.white,
                                                  ),
                                          ),
                                          hSpace(10),
                                          getCustomFont(
                                            snapshot.data!
                                                    .data()?["username"]
                                                    .toString()
                                                    .capitalize ??
                                                "Amanda Simon",
                                            17,
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
                              const Spacer(),
                              getCustomFont(
                                widget.placeData != null
                                    ? formatDuration(
                                        widget.placeData?.createdAt?.toDate())
                                    : "2h ago",
                                14,
                                darkGrey,
                                1,
                                fontWeight: medium,
                              ),
                            ],
                          ),
                          vSpace(10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getCustomFont(
                                      "${widget.placeData?.name}",
                                      18,
                                      Colors.black,
                                      1,
                                      fontWeight: bold,
                                    ),
                                    getCustomFont(
                                      "${widget.placeData?.address}",
                                      12,
                                      Colors.black,
                                      2,
                                      fontWeight: regular,
                                    ),
                                  ],
                                ),
                              ),
                              hSpace(10),
                              GestureDetector(
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      widget.placeData?.latitude ?? 0,
                                      widget.placeData?.longitude ?? 0);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image(
                                    image: AssetImage("map".png),
                                    width: FetchPixels.getPixelWidth(110),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          vSpace(20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              getIconText(Icons.bed_rounded,
                                  "${widget.placeData?.beds ?? 0} Beds"),
                              getIconText(Icons.bathroom_outlined,
                                  "${widget.placeData?.bath ?? 0}  Bathrooms"),
                              getIconText(Icons.width_wide_outlined,
                                  "${widget.placeData?.sqft ?? 0}  sqft"),
                            ],
                          ),
                          vSpace(10),
                          const Divider(
                            thickness: 1,
                            color: grey,
                          ),
                          if (widget.isManagePlaceList)
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => PdfView(
                                          url: widget.placeData?.documentUrl ??
                                              "",
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD33B35),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: getPaddingWidget(
                                      EdgeInsets.symmetric(
                                        vertical:
                                            FetchPixels.getPixelHeight(10),
                                        horizontal:
                                            FetchPixels.getPixelWidth(15),
                                      ),
                                      child: Row(
                                        children: [
                                          getCustomFont(
                                            "Land Documents",
                                            15,
                                            Colors.white,
                                            1,
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          vSpace(15),
                          getCustomFont(
                            widget.placeData?.description ?? "",
                            16,
                            darkGrey,
                            1000,
                            fontWeight: regular,
                            textAlign: TextAlign.justify,
                          ),
                          vSpace(15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
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
            child: getPaddingWidget(
              edgeInsets,
              child: SafeArea(
                bottom: true,
                top: false,
                child: getPaddingWidget(
                  EdgeInsets.symmetric(
                    vertical: FetchPixels.getPixelHeight(
                        widget.isManagePlaceList ? 20 : 25),
                  ),
                  child: widget.isManagePlaceList
                      ? Column(
                          children: [
                            Row(
                              children: [
                                getCustomFont(
                                  "$ ${formatPrice(double.parse(widget.placeData!.price!))}",
                                  22,
                                  Colors.black,
                                  1,
                                  fontWeight: bold,
                                ),
                                if (!(widget.placeData?.isForSale ?? true))
                                  getCustomFont(
                                    " /month",
                                    16,
                                    darkGrey,
                                    1,
                                  ),
                              ],
                            ),
                            vSpace(15),
                            Row(
                              children: [
                                Expanded(
                                  child: SecondaryButton(
                                    title: "Reject",
                                    isFromProfile: true,
                                    padding: EdgeInsets.symmetric(
                                      vertical: FetchPixels.getPixelHeight(12),
                                      horizontal: FetchPixels.getPixelWidth(17),
                                    ),
                                    color: Colors.redAccent,
                                    onTap: () {
                                      rejectSheet();
                                    },
                                  ),
                                ),
                                hSpace(10),
                                Expanded(
                                  child: PrimaryButton(
                                    "Approve",
                                    radius: 10,
                                    onTap: () {
                                      data.approvePlace(
                                          widget.placeData?.placeId);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            getCustomFont(
                              "$ ${formatPrice(double.parse(widget.placeData!.price!))}",
                              22,
                              Colors.black,
                              1,
                              fontWeight: bold,
                            ),
                            if (!(widget.placeData?.isForSale ?? true))
                              getCustomFont(
                                " /month",
                                16,
                                darkGrey,
                                1,
                              ),
                            const Spacer(),
                            PrimaryButton(
                              widget.isMyPlace
                                  ? widget.placeData?.rejectedReason != null
                                      ? "Rejected"
                                      : widget.placeData?.isApproved ?? false
                                          ? "Active"
                                          : "In Review"
                                  : "Call",
                              onTap: () {
                                if (widget.isMyPlace) {
                                  if (widget.placeData?.rejectedReason !=
                                      null) {
                                    data.showAlert(context,
                                        widget.placeData?.rejectedReason);
                                  }
                                } else {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: widget.placeData?.mobile,
                                  );
                                  launchUrl(launchUri);
                                }
                              },
                              buttonColor: widget.isMyPlace
                                  ? widget.placeData?.rejectedReason != null
                                      ? Colors.redAccent
                                      : widget.placeData?.isApproved == true
                                          ? green
                                          : darkGrey
                                  : darkBlue,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
