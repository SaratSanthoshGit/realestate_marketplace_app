import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:realestate_marketplace_app/widget/appbar/first_appbar.dart';

import '../../utils/resizer/fetch_pixels.dart';

class PdfView extends StatelessWidget {
  final String url;

  const PdfView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: FetchPixels.getPixelHeight(8),
              horizontal: FetchPixels.getPixelHeight(16),
            ),
            child: const FirstAppBar(title: ''),
          ),
          Expanded(
            child: PDF().cachedFromUrl(url),
          ),
        ],
      ),
    );
  }
}
