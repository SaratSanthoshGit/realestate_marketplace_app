import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart';


import '../utils/resizer/fetch_pixels.dart';

class Search extends StatelessWidget {
  Function(String)? onChange;
  final TextEditingController? controller;
  final bool? enable;

  Search({super.key, this.onChange, this.controller, this.enable});

 
  @override
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FetchPixels.getPixelHeight(40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          // Your TextField properties here
        ),
      ),
    );
  }
}
