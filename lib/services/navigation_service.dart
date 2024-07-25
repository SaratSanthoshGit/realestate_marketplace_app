import 'package:flutter/material.dart';

class NavigationService {
  static void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}