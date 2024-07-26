import 'package:flutter/material.dart';

class VMTextBox {
  final String placeholder;
  final TextEditingController controller = TextEditingController();
  Widget? prefixIcon;
  final TextInputType? keyboardType;
  String get text {
    return controller.text;
  }

  VMTextBox({
    required this.placeholder,
    this.prefixIcon,
    this.keyboardType,
  });
}
