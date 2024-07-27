import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:realestate_marketplace_app/controller/route_controller.dart';
import 'package:realestate_marketplace_app/screens/home/vm_home.dart';
import 'package:realestate_marketplace_app/utils/manager/loading_manager.dart';
import 'package:realestate_marketplace_app/utils/manager/toast_manager.dart';
import 'package:logging/logging.dart';
import '../../utils/c_extensions.dart';
import '../textbox/vm_textbox.dart';

class VMLogin extends GetxController {
  final formKey = GlobalKey<FormState>();
  final _logger = Logger('VMLogin');

  RxBool isLoggedIn = RxBool(false);
  Rxn<File> selectedImages = Rxn<File>();
  Rxn<User> loggedInUser = Rxn();

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _logger.info('Auth state changed: ${user?.uid}');
      loggedInUser.value = user;
      isLoggedIn.value = user != null;
    });
  }

  final name = VMTextBox(
    placeholder: 'Full Name',
    keyboardType: TextInputType.text,
  );
  final emailId = VMTextBox(
    placeholder: 'Email Id',
    keyboardType: TextInputType.emailAddress,
  );
  final password = VMTextBox(
    placeholder: 'Password',
    keyboardType: TextInputType.visiblePassword,
  );

  bool validate({bool withName = false}) {
    hideKeyboard();
    if (!emailId.text.trim().isEmail) {
      ToastManager.shared.show("Please enter valid emailId!");
      return false;
    }
    if (withName && name.text.trim().isEmpty) {
      ToastManager.shared.show("Please enter your name!");
      return false;
    }
    if (password.text.trim().length < 6) {
      ToastManager.shared.show("Password should be about 6 characters!");
      return false;
    }
    return true;
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final Directory tempDir = await getTemporaryDirectory();
      var cResult = await FlutterImageCompress.compressAndGetFile(
        result.files.first.path!,
        "${tempDir.path}/${result.files.first.name.split('.').first}.png",
        quality: 10,
        format: CompressFormat.png,
      );
      selectedImages.value = File(cResult!.path);
      selectedImages.refresh();
    }
  }

  Future<void> updateProfile(Function() onDone) async {
    if (selectedImages.value != null) {
      try {
        LoadingManager.shared.showLoading();
        User? user = FirebaseAuth.instance.currentUser;
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('user_profile/${user?.uid}.png');

        UploadTask uploadTask = storageReference.putFile(selectedImages.value!);

        await uploadTask.whenComplete(() async {
          String imageUrl = await storageReference.getDownloadURL();
          _logger.info('Image URL: $imageUrl');
          await user?.updatePhotoURL(imageUrl);
          await user?.reload();
          await FirebaseFirestore.instance.collection("users").doc(user?.uid).update({
            "photo_url": imageUrl,
          });
          loggedInUser.value = FirebaseAuth.instance.currentUser;
          onDone();
        });
      } catch (e) {
        ToastManager.shared.show("Something went wrong!");
        _logger.severe('Error uploading image: $e');
      } finally {
        LoadingManager.shared.hideLoading();
      }
    } else {
      onDone();
    }
  }

  Future<void> login() async {
    if (validate()) {
      LoadingManager.shared.showLoading();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailId.text,
          password: password.text,
        );
        await FirebaseAuth.instance.currentUser?.reload();
        loggedInUser.value = FirebaseAuth.instance.currentUser;
        Get.back();

        emailId.controller.clear();
        password.controller.clear();
        name.controller.clear();
      } on FirebaseAuthException catch (e) {
        _logger.warning('Firebase Auth Exception: ${e.code}');
        if (e.code == 'user-not-found') {
          ToastManager.shared.show("No user found for that email.");
        } else if (e.code == 'wrong-password') {
          ToastManager.shared.show("Wrong password provided for that user.");
        } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          ToastManager.shared.show("Invalid login credentials.");
        }
      } catch (e) {
        _logger.severe('Unexpected error during login: $e');
      } finally {
        LoadingManager.shared.hideLoading();
      }
    }
  }

  Future<void> signUp() async {
    if (validate(withName: true)) {
      LoadingManager.shared.showLoading();
      try {
        UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailId.text,
          password: password.text,
        );
        User? user = credential.user;
        if (user != null) {
          await user.updateDisplayName(name.text);
          await user.reload();
          await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
            "username": name.text,
            "uid": user.uid,
            "photo_url": user.photoURL,
            "likes": 0,
            "places": 0,
            "views": 0,
            "created_at": Timestamp.now(),
          });
          loggedInUser.value = FirebaseAuth.instance.currentUser;
          _logger.info('User signed up: ${user.uid}');
        }

        Get.back();

        emailId.controller.clear();
        password.controller.clear();
        name.controller.clear();
      } on FirebaseAuthException catch (e) {
        _logger.warning('Firebase Auth Exception during signup: ${e.code}');
        if (e.code == 'weak-password') {
          ToastManager.shared.show("The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          ToastManager.shared.show("The account already exists for that email.");
        }
      } catch (e) {
        _logger.severe('Unexpected error during signup: $e');
      } finally {
        LoadingManager.shared.hideLoading();
      }
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await FirebaseAuth.instance.currentUser?.reload();
    VMHome.to.favorites.value = [];
    RouteController.to.currentPos.value = 0;
    _logger.info('User logged out');
  }
}