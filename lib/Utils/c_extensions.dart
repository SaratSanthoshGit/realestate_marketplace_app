import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:realestate_marketplace_app/Utils/resizer/fetch_pixels.dart';
import 'manager/color_manager.dart';

// Define the CommonController class
class CommonController extends GetxController {
  bool isLoading = false;
}

// Define the getDefaultDecoration method
BoxDecoration getDefaultDecoration({required BuildContext context, double radius = 0}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;

  String removeAllHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return replaceAll(exp, '');
  }
}

extension WidgetExtentions on Widget {
  addShadow(context) {
    return Container(
      padding: EdgeInsets.all(FetchPixels.getPixelWidth(5)),
      decoration: getDefaultDecoration(
        context: context,
        radius: 10,
      ),
      child: this,
    );
  }

  stackLoading({backColor}) {
    return Stack(
      children: [
        this,
        GetBuilder<CommonController>(
          builder: (CommonController controller) => Visibility(
            visible: controller.isLoading,
            child: Container(
              decoration: BoxDecoration(
                color: backColor ?? const Color(0xA5000000),
              ),
              child: Center(
                child: Platform.isAndroid
                    ? const CircularProgressIndicator(
                        color: Color(0xfff46f4c),
                      )
                    : const CupertinoActivityIndicator(
                        color: Color(0xfff46f4c),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

extension Storage on String {
  get png => "assets/images/$this.png";
  get lottieAnimation => "assets/animations/$this.json";
  get railwayImage => "assets/railway_images/$this";
  get lottie => "assets/animations/$this.json";
}

getErrorMessage(msg) {
  return Center(
    child: Text(
      msg == null || msg.toString().contains("subtype")
          ? "Something went wrong! please try again later."
          : msg.toString().contains("SocketException")
              ? "Please check your internet connection!"
              : msg.toString(),
      style: const TextStyle(
        color: white,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

hideKeyboard() {
  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
}

unFocus(PointerDownEvent event) {
  hideKeyboard();
}

String formatDuration(timestamp) {
  Duration duration = DateTime.now().difference(timestamp);
  if (duration.inDays > 0) {
    final days = duration.inDays;
    return '$days d${days > 1 ? 's' : ''} ago';
  } else if (duration.inHours > 0) {
    final hours = duration.inHours;
    return '$hours h${hours > 1 ? 's' : ''} ago';
  } else if (duration.inMinutes > 0) {
    final minutes = duration.inMinutes;
    return '$minutes m${minutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
