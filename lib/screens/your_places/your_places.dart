import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:realestate_marketplace_app/controller/route_controller.dart';
import 'package:realestate_marketplace_app/model/place_model.dart';
import 'package:realestate_marketplace_app/utils/manager/loading_manager.dart';

import '../../utils/manager/font_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../../widget/appbar/common_appbar.dart';
import '../../widget/home_card.dart';
import '../../widget/widget_utils.dart';

class YourPlaces extends StatelessWidget {
  YourPlaces({super.key});

  final Logger _logger = Logger('YourPlaces');

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        RouteController.to.currentPos.value = 0;
      },
      child: Scaffold(
        appBar: CommonAppBar(isMyPlace: true),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("places")
              .where("user_id",
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading;
            } else if (snapshot.hasData) {
              List<PlaceModel> list = snapshot.data!.docs.map(
                (e) {
                  _logger.info('Place data: ${e.data()}');
                  return PlaceModel.fromJson(
                    e.data(),
                  );
                },
              ).toList();
              return list.isEmpty
                  ? emptyView("Click above + button to create your place.")
                  : SingleChildScrollView(
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
                              "Your Places",
                              20,
                              Colors.black,
                              1,
                              fontWeight: bold,
                            ),
                            vSpace(15),
                            ListView.builder(
                              itemCount: list.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 6),
                              itemBuilder: (BuildContext context, int index) {
                                return getPaddingWidget(
                                  EdgeInsets.only(
                                    bottom: FetchPixels.getPixelHeight(20),
                                  ),
                                  child: HomeCard(
                                    isDetailedList: true,
                                    isMyPlaceList: true,
                                    placeData: list[index],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
            } else {
              _logger.warning('Error in StreamBuilder: ${snapshot.error}');
              return getErrorMessage();
            }
          },
        ),
      ),
    );
  }
}