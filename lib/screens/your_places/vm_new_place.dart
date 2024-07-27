import 'dart:io';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realestate_marketplace_app/model/place_model.dart';
import 'package:realestate_marketplace_app/utils/manager/toast_manager.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';
import '../../model/category_model.dart';
import '../../utils/c_extensions.dart';
import '../../utils/manager/color_manager.dart';
import '../../utils/manager/font_manager.dart';
import '../../utils/manager/loading_manager.dart';
import '../textbox/vm_textbox.dart';

class VMNewPlace extends GetxController {
  final logger = Logger();
  Rx<List<Marker>> customMarkers = Rx([]);
  Rxn<File> selectedPdf = Rxn<File>();
  Rx<List<File>> selectedImages = Rx<List<File>>([]);
  Position? currentLocation;

  pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      selectedPdf.value = File(result.files.first.path!);
    } else {}
  }

  pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    final Directory tempDir = await getTemporaryDirectory();
    if (result != null) {
      for (var e in result.files) {
        var cResult = await FlutterImageCompress.compressAndGetFile(
          e.path!,
          "${tempDir.path}/${e.name.split('.').first}.png",
          quality: 25,
          format: CompressFormat.png,
        );
        if (cResult != null) {
          selectedImages.value.insert(0, File(cResult.path));
        }
      }
      selectedImages.refresh();
    } else {}
  }

  reOrderImage(oldIndex, newIndex) {
    File removedFile = selectedImages.value.removeAt(oldIndex);
    selectedImages.value.insert(newIndex, removedFile);
    selectedImages.refresh();
  }

  removeImage(index) {
    selectedImages.value.removeAt(index);
    selectedImages.refresh();
  }

  final name = VMTextBox(
    placeholder: 'Place Name',
    keyboardType: TextInputType.text,
  );
  final mobile = VMTextBox(
    placeholder: 'Mobile Number',
    keyboardType: TextInputType.visiblePassword,
  );
  final address = VMTextBox(
    placeholder: 'Address',
    keyboardType: TextInputType.emailAddress,
  );
  final beds = VMTextBox(
    placeholder: 'Beds',
    keyboardType: TextInputType.visiblePassword,
  );
  final bath = VMTextBox(
    placeholder: 'Bathrooms',
    keyboardType: TextInputType.visiblePassword,
  );
  final sqft = VMTextBox(
    placeholder: 'Sqft',
    keyboardType: TextInputType.visiblePassword,
  );
  final price = VMTextBox(
    placeholder: 'Price',
    keyboardType: TextInputType.visiblePassword,
  );
  final description = VMTextBox(
    placeholder: 'Description',
    keyboardType: TextInputType.visiblePassword,
  );
  Rxn<CategoryModel> selectedItem = Rxn();

  bool validate({bool withOTP = true}) {
    hideKeyboard();
    if (name.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter name!");
      return false;
    }
    if (!mobile.text.trim().isPhoneNumber) {
      ToastManager.shared.show("Please enter valid number!");
      return false;
    }
    if (selectedItem.value == null) {
      ToastManager.shared.show("Please select a category!");
      return false;
    }
    if (address.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter the address!");
      return false;
    }
    if (price.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter the price!");
      return false;
    }
    if (!price.text.isNumeric) {
      ToastManager.shared.show("Please enter valid price!");
      return false;
    }
    if (beds.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter bedroom count!");
      return false;
    }
    if (!beds.text.isNumeric) {
      ToastManager.shared.show("Please enter valid bedroom count!");
      return false;
    }
    if (bath.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter bathroom count!");
      return false;
    }
    if (!bath.text.isNumeric) {
      ToastManager.shared.show("Please enter valid bathroom count!");
      return false;
    }
    if (sqft.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter sqft!");
      return false;
    }
    if (!sqft.text.isNumeric) {
      ToastManager.shared.show("Please enter valid sqft!");
      return false;
    }
    if (selectedPdf.value == null) {
      ToastManager.shared.show("Please select land document for validation!");
      return false;
    }
    if (selectedImages.value.isEmpty) {
      ToastManager.shared.show("Please select place images!");
      return false;
    }
    if (description.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter description!");
      return false;
    }
    if (customMarkers.value.isEmpty) {
      ToastManager.shared.show("Please pick place location on map!");
      return false;
    }
    return true;
  }

  showAlert(context, reason) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: getCustomFont(
          "Reason for rejection!",
          18,
          Colors.redAccent,
          1,
          fontWeight: bold,
        ),
        content: SingleChildScrollView(
          child: getCustomFont(
            reason,
            14,
            darkGrey,
            1000,
            fontWeight: semiBold,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }

  storePlaceDate(bool isForSale) async {
    if (!validate()) {
      return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    var randomDoc = FirebaseFirestore.instance.collection("places").doc();

    LoadingManager.shared.showLoading();

    try {
      String? url = await uploadDocument(randomDoc.id);
      if (url != null) {
        List<String> urls = await uploadImages(randomDoc.id);

        if (urls.isNotEmpty) {
          PlaceModel placeModel = PlaceModel(
            userId: user?.uid,
            placeId: randomDoc.id,
            name: name.text,
            mobile: mobile.text,
            categoryId: selectedItem.value!.id,
            address: address.text,
            price: price.text,
            isForSale: isForSale,
            isApproved: false,
            rejectedReason: null,
            beds: beds.text,
            bath: bath.text,
            sqft: sqft.text,
            documentUrl: url,
            imagesUrl: urls,
            description: description.text,
            latitude: customMarkers.value.first.point.latitude,
            longitude: customMarkers.value.first.point.longitude,
            createdAt: Timestamp.now(),
          );

          randomDoc.set(
            placeModel.toJson(),
          );
          updatePlaceCount();

          name.controller.clear();
          mobile.controller.clear();
          selectedItem.value = null;
          address.controller.clear();
          price.controller.clear();
          beds.controller.clear();
          bath.controller.clear();
          sqft.controller.clear();
          selectedPdf.value = null;
          selectedImages.value = [];
          description.controller.clear();
          customMarkers.value = [];

          Get.back();
        }
      }
    } catch (e) {
      logger.e(e);
      ToastManager.shared.show("Failed to create place!");
    } finally {
      LoadingManager.shared.hideLoading();
    }
  }

  deletePlace(documentId) async {
    LoadingManager.shared.showLoading();
    User? user = FirebaseAuth.instance.currentUser;

    var randomDoc =
        FirebaseFirestore.instance.collection("places").doc(documentId);

    Reference storageReference =
        FirebaseStorage.instance.ref().child('places/${user?.uid}/$documentId');

    try {
      randomDoc.delete();
      final result = await storageReference.listAll();
      for (final item in result.items) {
        await item.delete();
      }
      ToastManager.shared.show("Place deleted successfully!");

      var userRef =
          FirebaseFirestore.instance.collection("users").doc(user?.uid);
      DocumentSnapshot<Map<String, dynamic>> profileData = await userRef.get();
      int places = profileData.data()?["places"];
      if (places <= 0) {
        userRef.update({"places": 0});
      } else {
        userRef.update({"places": places - 1});
      }
    } catch (e) {
      logger.e('Error deleting image: $e');
      ToastManager.shared.show("Failed to delete place!");
    } finally {
      LoadingManager.shared.hideLoading();
    }
  }

  updatePlaceCount() async {
    User? user = FirebaseAuth.instance.currentUser;

    var userRef = FirebaseFirestore.instance.collection("users").doc(user?.uid);

    DocumentSnapshot<Map<String, dynamic>> profileData = await userRef.get();

    userRef.update({"places": profileData.data()?["places"] + 1});
  }

  approvePlace(placeId) async {
    try {
      FirebaseFirestore.instance.collection("places").doc(placeId).update({
        "isApproved": true,
      });
      Get.back();
    } catch (e) {
      logger.e(e);
      ToastManager.shared.show("Failed to approve place!");
    }
  }

  rejectPlace(placeId, reason) async {
    try {
      FirebaseFirestore.instance.collection("places").doc(placeId).update({
        "isApproved": false,
        "rejected_reason": reason,
      });
      Get.back();
      Get.back();
    } catch (e) {
      logger.e(e);
      ToastManager.shared.show("Failed to reject place!");
    }
  }

  Future determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToastManager.shared.show("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastManager.shared.show("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ToastManager.shared.show(
          "Location permissions are permanently denied, we cannot request permissions.");
    }

    currentLocation = await Geolocator.getCurrentPosition();
    logger.i(currentLocation);
  }

  Future<List<String>> uploadImages(documentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      List<String> downloadUrls = [];
      ToastManager.shared.show("Uploading images");

      for (var element in selectedImages.value) {
        Reference storageReference = FirebaseStorage.instance.ref().child(
            'places/${user?.uid}/$documentId/${selectedImages.value.indexOf(element)}.png');
        UploadTask uploadTask = storageReference.putFile(element);
        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          downloadUrls.add(imageUrl);
          logger.i('Image URL: $imageUrl');
        });
      }

      return downloadUrls;
    } catch (e) {
      ToastManager.shared.show("Failed to upload images!");
      logger.e('Error uploading image: $e');
      return [];
    }
  }

  Future<String?> uploadDocument(documentId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      String? url;
      ToastManager.shared.show("Uploading land document");

      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('places/${user?.uid}/$documentId/land-document.pdf');
      UploadTask uploadTask = storageReference.putFile(selectedPdf.value!);
      await uploadTask.whenComplete(() async {
        String imageUrl = await storageReference.getDownloadURL();
        url = imageUrl;
        logger.i('Image URL: $imageUrl');
      });
      return url;
    } catch (e) {
      ToastManager.shared.show("Failed to upload land document!");
      logger.e('Error uploading image: $e');
      return null;
    }
  }
}