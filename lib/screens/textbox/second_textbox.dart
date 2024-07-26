import 'package:flutter/material.dart';
import '../../imports/ui_element.dart';

class SecondTextBox extends StatelessWidget {
  const SecondTextBox(
      {super.key,
      required this.data,
      this.prefixIcon,
      this.onChange,
      this.enabled = true,
      this.isInEditMode = false});
  final VMTextBox data;
  final Function(String)? onChange;
  final Widget? prefixIcon;
  final bool enabled;
  final bool isInEditMode;
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: secondFont,
      fontWeight: semiBold,
      fontSize: 14,
      color: textColor2.withOpacity(0.7),
    );
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: isInEditMode ? null : textColor1,
        border: Border.all(
          color: isInEditMode ? textColor2 : expireGrey2,
          width: isInEditMode ? 1 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
              blurRadius: 15,
              offset: const Offset(2, 2),
              spreadRadius: 0,
              color: Colors.black.withOpacity(0.05))
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: TextField(
          controller: data.controller,
          onChanged: onChange,
          enabled: enabled,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: data.placeholder,
            hintStyle: textStyle,
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: prefixIcon!,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minHeight: 30,
            ),
          ),
          style: textStyle,
        ),
      ),
    );
  }
}
