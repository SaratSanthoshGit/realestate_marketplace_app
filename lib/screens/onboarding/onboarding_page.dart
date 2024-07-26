import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:realestate_marketplace_app/screens/dashboard/dashboard.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';

import '../../widget/widget_utils.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({super.key});

  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Sell a home',
              body:
                  'Whether you choose traditional listing or explore innovative selling methods, we\'re here to guide you towards a successful home sale.',
              image: buildImage('sale'.png),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Buy a home',
              body:
                  'Discover your perfect home with us, where comfort meets your vision of a dream property.',
              image: buildImage('buy'.png),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Rent a home',
              body:
                  'Discover your next home to rent, where convenience and comfort await.',
              image: buildImage('rent'.png),
              decoration: getPageDecoration(),
            ),
          ],
          done: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: getCustomFont("Next", 18, Colors.white, 1),
            ),
          ),
          onDone: () => goToPhoneNumberScreen(context),
          showSkipButton: true,
          skip: getCustomFont("Skip", 15, Colors.black, 1),
          onSkip: () => goToPhoneNumberScreen(context),
          skipStyle: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(
            Colors.black,
          )),
          next: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Padding(
              padding: EdgeInsets.all(14.0),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
          dotsDecorator: getDotDecoration(),
          globalBackgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  void goToPhoneNumberScreen(context) {
    box.write("isSkipped", true);
    Get.offAll(
      () => Dashboard(),
      transition: Transition.fadeIn,
    );
  }

  Widget buildImage(String path) {
    return Center(
      child: Image.asset(
        path,
        width: double.infinity,
      ),
    );
  }

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Colors.black87,
        activeColor: Colors.black,
        size: const Size(10, 10),
        activeSize: const Size(22, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyTextStyle: const TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        footerPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
      );
}
