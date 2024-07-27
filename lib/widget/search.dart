import 'package:flutter/material.dart';
import '../utils/resizer/fetch_pixels.dart';

class Search extends StatelessWidget {
  final Function(String)? onChange;
  final TextEditingController? controller;
  final bool? enable;

  const Search({
    super.key,
    this.onChange,
    this.controller,
    this.enable,
  });

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