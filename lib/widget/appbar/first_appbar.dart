import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../../utils/manager/color_manager.dart';
import '../../utils/manager/font_manager.dart';
import '../../utils/resizer/fetch_pixels.dart';

class FirstAppBar extends StatelessWidget {
  final String title;
  final Widget? action;
  final Function()? onBack;

  const FirstAppBar({super.key, required this.title, this.action, this.onBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: SizedBox(
        height: FetchPixels.getPixelHeight(60),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                CustomBack(
                  onBack: onBack,
                ),
                const Spacer(),
                if (action != null) action!,
              ],
            ),
            getCustomFont(
              title,
              19,
              Colors.black,
              1,
              fontWeight: bold,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBack extends StatelessWidget {
  final Function()? onBack;
  final Color color;

  const CustomBack({super.key, this.onBack, this.color = darkGrey});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          child: InkWell(
            onTap: onBack ??
                () {
                  Get.back();
                },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, right: 4, left: 1),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  // hSpace(3),
                  Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 14,
                      color: color,
                    ),
                    maxLines: 1,
                  ),
                  // getCustomFont(
                  //   "Back",
                  //   14,
                  //   color,
                  //   1,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
