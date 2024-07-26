import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/screens/home/map_view.dart';
import 'package:realestate_marketplace_app/screens/home/vm_home.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart';
import 'package:realestate_marketplace_app/utils/resizer/fetch_pixels.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../../model/place_model.dart';
import '../../utils/manager/loading_manager.dart';
import '../../widget/appbar/first_appbar.dart';
import '../../widget/home_card.dart';

class HomeList extends StatelessWidget {
  final String title;
  final bool isRent;
  final List<PlaceModel> place;

  const HomeList(this.title, this.isRent, this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    VMHome vmHome = VMHome.to;

    EdgeInsets edgeInsets = const EdgeInsets.symmetric(horizontal: 15);
    return Scaffold(
      body: getPaddingWidget(
        edgeInsets,
        child: Column(
          children: [
            FirstAppBar(
              title: title,
              action: IconButton(
                onPressed: () {
                  Get.to(
                    () => MapView(
                      place: place,
                    ),
                  );
                },
                icon: const CircleAvatar(
                  backgroundColor: darkBlue,
                  child: Icon(
                    Icons.map_rounded,
                    color: white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loading;
                        } else if (snapshot.hasData) {
                          Map<String, dynamic>? userFireData =
                              snapshot.data!.data();
                          vmHome.favorites.value =
                              userFireData?["favorites"] ?? [];

                          return Container();
                        } else {
                          return Container();
                        }
                      }),
                  Expanded(child: GetBuilder<VMHome>(
                    builder: (VMHome controller) {
                      return ListView.builder(
                        itemCount: place.length,
                        padding: const EdgeInsets.only(top: 6),
                        itemBuilder: (BuildContext context, int index) {
                          return getPaddingWidget(
                            EdgeInsets.only(
                              bottom: FetchPixels.getPixelHeight(20),
                            ),
                            child: HomeCard(
                              isDetailedList: true,
                              isRentList: isRent,
                              placeData: place[index],
                              isLiked: controller.favorites
                                  .contains(place[index].placeId),
                            ),
                          );
                        },
                      );
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
