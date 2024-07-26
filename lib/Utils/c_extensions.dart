import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'manager/color_manager.dart';

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

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;

  String removeAllHtmlTags() {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return replaceAll(exp, '');
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
