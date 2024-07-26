import 'package:flutter/material.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart';
import 'package:realestate_marketplace_app/utils/manager/font_manager.dart';
import 'package:realestate_marketplace_app/utils/resizer/fetch_pixels.dart';

import '../widget_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final double? radius;
  final EdgeInsets? padding;
  final Color buttonColor;
  final Function()? onTap;

  const PrimaryButton(this.title,
      {super.key, this.radius, this.padding, this.onTap, this.buttonColor = darkBlue});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: buttonColor,
        // side: const BorderSide(color: Colors.white, width: 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 30.0),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      onPressed: onTap,
      child: getPaddingWidget(
        padding ??
            EdgeInsets.symmetric(
              vertical: FetchPixels.getPixelHeight(12),
              horizontal: FetchPixels.getPixelWidth(17),
            ),
        child: getCustomFont(
          title,
          16,
          Colors.white,
          1,
          fontWeight: bold,
        ),
      ),
    );
  }
}
