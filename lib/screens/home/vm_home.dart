import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../model/category_model.dart';

class VMHome extends GetxController {
  static VMHome to = Get.find();

  RxList favorites = RxList([]);

  List<CategoryModel> category = [
    CategoryModel(1, "House", "house"),
    CategoryModel(2, "Apartment", "apartment"),
    CategoryModel(3, "Skyscraper", "skyscrapers"),
    CategoryModel(4, "Farmhouse", "farmhouse"),
    CategoryModel(5, "Townhouse", "townhouse"),
    CategoryModel(6, "Cottage", "cottage"),
    CategoryModel(7, "Duplex", "duplex"),
    CategoryModel(8, "Mansion", "mansion"),
    CategoryModel(9, "Penthouse", "penthouse"),
  ];

  addToFavorites(placeId, placeOwnerId) async {
    User? user = FirebaseAuth.instance.currentUser;

    var userRef = FirebaseFirestore.instance.collection("users").doc(user?.uid);

    DocumentSnapshot<Map<String, dynamic>> profileData = await userRef.get();

    if (profileData.data() != null) {
      List favorites = profileData.data()?["favorites"] ?? [];
      if (!favorites.contains(placeId)) {
        favorites.insert(0, placeId);
        userRef.update(
          {"favorites": favorites},
        );

        var uR =
            FirebaseFirestore.instance.collection("users").doc(placeOwnerId);
        DocumentSnapshot<Map<String, dynamic>> pD = await uR.get();
        if (pD.data() != null) {
          uR.update({"likes": pD.data()?["likes"] + 1});
        }
      }
    }
  }

  removeFromFavorites(placeId, placeOwnerId) async {
    User? user = FirebaseAuth.instance.currentUser;

    var userRef = FirebaseFirestore.instance.collection("users").doc(user?.uid);

    DocumentSnapshot<Map<String, dynamic>> profileData = await userRef.get();

    if (profileData.data() != null) {
      List favorites = profileData.data()?["favorites"] ?? [];
      if (favorites.contains(placeId)) {
        favorites.remove(placeId);
        userRef.update(
          {"favorites": favorites},
        );

        var uR =
            FirebaseFirestore.instance.collection("users").doc(placeOwnerId);
        DocumentSnapshot<Map<String, dynamic>> pD = await uR.get();
        if (pD.data() != null) {
          int likes = pD.data()?["likes"];
          if (likes <= 0) {
            uR.update({"likes": 0});
          } else {
            uR.update({"likes": likes - 1});
          }
        }
      }
    }
  }
}
