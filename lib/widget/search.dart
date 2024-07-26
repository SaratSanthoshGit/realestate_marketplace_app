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

  Rx<bool> isListening = Rx(false);
  SpeechToText speech = SpeechToText();

  onMikeStop() async {
    if (onChange != null) {
      onChange!(controller!.text);
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: FetchPixels.getPixelHeight(40),
      // decoration: const BoxDecoration(
      //   color: Color(0xFFebebec),
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(10.0),
      //   ),
      // ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: TextField(
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: controller,
          maxLines: 1,
          onChanged: onChange,
          enabled: enable,
          autofocus: enable ?? false,
          decoration: InputDecoration(
            hintText: "Search",
            hintStyle: const TextStyle(
              color: darkGrey,
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: const Color(0xFFebebec),
            // contentPadding: EdgeInsets.symmetric(vertical: 2.5),
            prefixIcon: Icon(
              Icons.search,
              color: darkGrey,
              size: FetchPixels.getHeightPercentSize(3),
            ),
            suffixIcon: enable == true
                ? InkWell(
                    onTap: () {
                      onListen(context);
                    },
                    child: Obx(
                      () => AvatarGlow(
                        animate: isListening.value,
                        glowColor: darkBlue,
                        endRadius: 15,
                        duration: const Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        child: Icon(
                          isListening.value ? Icons.mic_none : Icons.mic,
                          color: darkBlue,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    Icons.mic,
                    color: darkGrey,
                    size: FetchPixels.getHeightPercentSize(3),
                  ),
          ),
        ),
      ),
    );
  }
}
