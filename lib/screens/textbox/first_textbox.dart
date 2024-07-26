import 'package:flutter/material.dart';
import 'package:realestate_marketplace_app/screens/textbox/vm_textbox.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';

import '../../utils/manager/color_manager.dart';
import '../../utils/manager/font_manager.dart';

class FirstTextBox extends StatelessWidget {
  const FirstTextBox({
    super.key,
    required this.data,
    this.isNeedTopPlaceholder = true,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled,
    this.obscureText,
    this.maxLines,
  });
  final VMTextBox data;
  final bool isNeedTopPlaceholder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? obscureText;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isNeedTopPlaceholder)
          getCustomFont(
            data.placeholder,
            14,
            darkGrey,
            1,
          ),
        if (isNeedTopPlaceholder) const SizedBox(height: 10),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: grey.withOpacity(.3),
            // border: Border.all(
            //   color: const Color(0xFF51B2FF).withOpacity(0.4),
            //   width: 0.5,
            // ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: data.controller,
              keyboardType: data.keyboardType,
              onTapOutside: unFocus,
              enabled: enabled,
              cursorColor: darkBlue,
              maxLines: maxLines ?? 1,
              obscureText: obscureText ?? false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: isNeedTopPlaceholder ? '' : data.placeholder,
                prefixIcon: prefixIcon != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: prefixIcon!,
                      )
                    : null,
                prefixIconConstraints: const BoxConstraints(
                  minHeight: 30,
                ),
                suffixIcon: suffixIcon,
                // suffixIconConstraints: BoxConstraints(
                //   minHeight: 50,
                // ),
              ),
              style: const TextStyle(
                fontWeight: semiBold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
