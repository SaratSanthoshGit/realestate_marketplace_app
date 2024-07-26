import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/widget/appbar/first_appbar.dart';

import '../../model/place_model.dart';
import '../../utils/manager/loading_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../../widget/home_card.dart';
import '../../widget/widget_utils.dart';

class ManagePlaces extends StatelessWidget {
  const ManagePlaces({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: FetchPixels.getPixelHeight(8),
          horizontal: FetchPixels.getPixelHeight(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FirstAppBar(
              title: "Manage Places",
              onBack: () {
                Get.back();
              },
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("places")
                    .where("isApproved", isEqualTo: false)
                    .where("rejected_reason", isNull: true)
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  // List channelUsers =
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loading;
                  } else if (snapshot.hasData) {
                    List<PlaceModel> list = snapshot.data!.docs.map(
                      (e) {
                        print(e.data());
                        return PlaceModel.fromJson(
                          e.data(),
                        );
                      },
                    ).toList();
                    return list.isEmpty
                        ? emptyView("No places found!")
                        : ListView.builder(
                            itemCount: list.length,
                            padding: const EdgeInsets.only(top: 6),
                            itemBuilder: (BuildContext context, int index) {
                              return getPaddingWidget(
                                EdgeInsets.only(
                                  bottom: FetchPixels.getPixelHeight(20),
                                ),
                                child: HomeCard(
                                  isDetailedList: true,
                                  isManagePlaceList: true,
                                  placeData: list[index],
                                ),
                              );
                            },
                          );
                  } else {
                    print(snapshot.error);
                    return getErrorMessage();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
