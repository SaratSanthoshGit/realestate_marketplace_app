import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final bool isFromProfile;
  final String? title;
  final EdgeInsets? padding;
  final Color? color;
  final double? radius;
  final Function()? onTap;

  const SecondaryButton({
    super.key,
    this.isFromProfile = false,
    this.title,
    this.padding,
    this.color,
    this.radius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: color ?? Colors.white,
          width: isFromProfile ? 1 : 2.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 12.0),
        ),
        textStyle: TextStyle(color: color ?? Colors.white),
      ),
      onPressed: onTap,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8.0),
        child: Text(
          title ?? "Logout",
          style: TextStyle(
            fontSize: isFromProfile ? 17 : 15,
            color: color ?? Colors.white,
          ),
          maxLines: 1,
        ),
        // child: getCustomFont(
        //   title ?? "Logout",
        //   isFromProfile ? 17 : 15,
        //   color ?? Colors.white,
        //   1,
        // ),
      ),
    );
  }
}
