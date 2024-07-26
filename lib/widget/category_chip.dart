import 'package:flutter/material.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../model/category_model.dart';
import '../utils/manager/color_manager.dart';
import '../utils/manager/font_manager.dart';
import '../utils/resizer/fetch_pixels.dart';

class CategoryChip extends StatelessWidget {
  final bool isActive;
  final CategoryModel data;
  final Function() onTap;

  const CategoryChip(this.data, this.isActive, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: FetchPixels.getPixelWidth(80),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? null
                : Border.all(
                    width: .5,
                    color: grey,
                  ),
            boxShadow: !isActive
                ? null
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(data.image.png),
                width: FetchPixels.getPixelWidth(30),
                height: FetchPixels.getPixelHeight(30),
                color: !isActive ? Colors.black : darkBlue,
              ),
              vSpace(3),
              getCustomFont(
                data.title,
                10.5,
                !isActive ? Colors.black : darkBlue,
                1,
                fontWeight: bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
