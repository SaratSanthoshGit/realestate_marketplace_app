// import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:realestate_marketplace_app/screens/textbox/first_textbox.dart';
import 'package:realestate_marketplace_app/screens/your_places/vm_new_place.dart';
import 'package:realestate_marketplace_app/utils/c_extensions.dart';
import 'package:realestate_marketplace_app/utils/manager/color_manager.dart';
import 'package:realestate_marketplace_app/widget/appbar/first_appbar.dart';
import 'package:realestate_marketplace_app/widget/buttons/primary_button.dart';
import 'package:realestate_marketplace_app/widget/widget_utils.dart';
import '../../model/category_model.dart';
import '../../utils/resizer/fetch_pixels.dart';
import '../home/vm_home.dart';

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
        offset: const Offset(0, 5),
      ),
    ],
  );
}

class AddNewPlace extends StatelessWidget {
  AddNewPlace({super.key});

  final VMHome vmHome = VMHome.to;
  final RxBool selectedWay = RxBool(true);
  final RxBool selectedMap = RxBool(true);

  Marker buildPin(LatLng point) => Marker(
        point: point,
        width: 40,
        height: 40,
        child: Image(
          image: AssetImage("home_marker".png),
        ),
      );

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final data = Get.find<VMNewPlace>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: FetchPixels.getPixelHeight(8),
            horizontal: FetchPixels.getPixelHeight(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FirstAppBar(
                title: "Add new place",
                onBack: () {
                  Get.back();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      vSpace(10),
                      FirstTextBox(data: data.name),
                      vSpace(15),
                      Row(
                        children: [
                          Expanded(
                            child: FirstTextBox(
                              data: data.mobile,
                              maxLines: 1,
                            ),
                          ),
                          hSpace(5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getCustomFont(
                                  "Category",
                                  14,
                                  darkGrey,
                                  1,
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Obx(
                                      () => DropdownButton<CategoryModel>(
                                        value: data.selectedItem.value,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        items: vmHome.category
                                            .map((CategoryModel items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items.title),
                                          );
                                        }).toList(),
                                        onChanged: (CategoryModel? newValue) {
                                          data.selectedItem.value = newValue;
                                        },
                                        isExpanded: true,
                                        underline: Container(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // ... (rest of the code remains the same)
                      vSpace(15),
                      SizedBox(
                        height: FetchPixels.getPixelHeight(180),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Obx(
                            () => FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                  initialCenter: const LatLng(20.5937, 78.9629),
                                  initialZoom: 5,
                                  onTap: (_, p) {
                                    if (selectedMap.value) {
                                      data.customMarkers.value = [buildPin(p)];
                                    }
                                  }),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.app',
                                ),
                                const MarkerLayer(
                                  markers: [],
                                ),
                                MarkerLayer(
                                  markers: data.customMarkers.value,
                                  rotate: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      vSpace(30),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              "Send For Approval",
                              radius: 10,
                              onTap: () {
                                data.storePlaceDate(selectedWay.value);
                              },
                            ),
                          ),
                        ],
                      ),
                      vSpace(40),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextPlusPicker extends StatelessWidget {
  final String text;
  final Function() onTap;

  const TextPlusPicker({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: getCustomFont(
            text,
            14,
            darkGrey,
            1,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: darkGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: getPaddingWidget(
              const EdgeInsets.all(4),
              child: const Icon(
                Icons.add,
                color: white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}