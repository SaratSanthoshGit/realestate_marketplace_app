import 'package:animated_toggle_switch/animated_toggle_switch.dart';
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

class AddNewPlace extends StatelessWidget {
  AddNewPlace({super.key});

  VMHome vmHome = VMHome.to;
  RxBool selectedWay = RxBool(true);
  RxBool selectedMap = RxBool(true);

  Marker buildPin(LatLng point) => Marker(
        point: point,
        builder: (ctx) => Image(
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
                      vSpace(15),
                      FirstTextBox(
                        data: data.address,
                        maxLines: 1,
                      ),
                      vSpace(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: FirstTextBox(
                              data: data.price,
                              maxLines: 1,
                            ),
                          ),
                          hSpace(5),
                          Expanded(
                            child: Obx(
                              () => AnimatedToggleSwitch<bool>.size(
                                current: selectedWay.value,
                                values: const [true, false],
                                indicatorSize:
                                    const Size.fromWidth(double.infinity),
                                customIconBuilder: (context, local, global) =>
                                    Text(
                                  (local.value ? 'Sale' : 'Rent'),
                                  style: TextStyle(
                                    color: Color.lerp(
                                      Colors.black,
                                      Colors.black,
                                      local.animationValue,
                                    ),
                                    fontSize: 15,
                                  ),
                                ),
                                borderWidth: 2.0,
                                iconAnimationType: AnimationType.onSelected,
                                style: ToggleStyle(
                                  indicatorColor: white,
                                  backgroundColor: const Color(0xFFebebec),
                                  borderColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                selectedIconScale: 1.0,
                                height: 50,
                                onChanged: (b) {
                                  selectedWay.value = b;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      vSpace(15),
                      Row(
                        children: [
                          Expanded(
                            child: FirstTextBox(
                              data: data.beds,
                              maxLines: 1,
                            ),
                          ),
                          hSpace(5),
                          Expanded(
                            child: FirstTextBox(
                              data: data.bath,
                              maxLines: 1,
                            ),
                          ),
                          hSpace(5),
                          Expanded(
                            child: FirstTextBox(
                              data: data.sqft,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      vSpace(15),
                      TextPlusPicker(
                        text: 'Select Land Document',
                        onTap: () {
                          data.pickDocument();
                        },
                      ),
                      vSpace(10),
                      Obx(
                        () => data.selectedPdf.value == null
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD33B35),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: getPaddingWidget(
                                      EdgeInsets.symmetric(
                                        vertical:
                                            FetchPixels.getPixelHeight(10),
                                        horizontal:
                                            FetchPixels.getPixelWidth(15),
                                      ),
                                      child: Row(
                                        children: [
                                          getCustomFont(
                                            "Land Documents",
                                            15,
                                            Colors.white,
                                            1,
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.picture_as_pdf,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              data.selectedPdf.value = null;
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  vSpace(15),
                                ],
                              ),
                      ),
                      TextPlusPicker(
                        text: "Select Images",
                        onTap: () {
                          data.pickImages();
                        },
                      ),
                      vSpace(10),
                      Obx(
                        () => data.selectedImages.value.isEmpty
                            ? Container()
                            : Column(
                                children: [
                                  SizedBox(
                                    height: FetchPixels.getPixelHeight(85),
                                    child: ReorderableListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          data.selectedImages.value.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          key: ValueKey(index),
                                          child: getPaddingWidget(
                                            const EdgeInsets.all(2),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Image(
                                                    width: FetchPixels
                                                        .getPixelWidth(150),
                                                    fit: BoxFit.cover,
                                                    image: FileImage(data
                                                        .selectedImages
                                                        .value[index]),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      data.removeImage(index);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: white
                                                            .withOpacity(.7),
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                      ),
                                                      child: getPaddingWidget(
                                                        const EdgeInsets.all(2),
                                                        child: const Icon(
                                                            Icons.close),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      onReorder: (int oldIndex, int newIndex) {
                                        data.reOrderImage(oldIndex, newIndex);
                                      },
                                    ),
                                  ),
                                  vSpace(15),
                                ],
                              ),
                      ),
                      FirstTextBox(
                        data: data.description,
                        maxLines: 6,
                      ),
                      vSpace(15),
                      Row(
                        children: [
                          getCustomFont(
                            "Select Location",
                            14,
                            darkGrey,
                            1,
                          ),
                        ],
                      ),
                      vSpace(10),
                      Obx(
                        () => AnimatedToggleSwitch<bool>.size(
                          current: selectedMap.value,
                          values: const [true, false],
                          indicatorSize: const Size.fromWidth(double.infinity),
                          customIconBuilder: (context, local, global) => Text(
                            (local.value
                                ? 'Pick From Map'
                                : 'Use Current Location'),
                            style: TextStyle(
                              color: Color.lerp(
                                Colors.black,
                                Colors.black,
                                local.animationValue,
                              ),
                              fontSize: 15,
                            ),
                          ),
                          borderWidth: 2.0,
                          iconAnimationType: AnimationType.onSelected,
                          style: ToggleStyle(
                            indicatorColor: white,
                            backgroundColor: const Color(0xFFebebec),
                            borderColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          selectedIconScale: 1.0,
                          height: 40,
                          onChanged: (b) {
                            selectedMap.value = b;
                            data.customMarkers.value = [];
                            if (!selectedMap.value) {
                              data.determinePosition();
                              if (data.currentLocation != null) {
                                data.customMarkers.value = [
                                  buildPin(LatLng(
                                    data.currentLocation!.latitude,
                                    data.currentLocation!.longitude,
                                  ))
                                ];
                                data.customMarkers.refresh();
                                _mapController.move(
                                  LatLng(
                                    data.currentLocation!.latitude,
                                    data.currentLocation!.longitude,
                                  ),
                                  8,
                                );
                              }
                            }
                          },
                        ),
                      ),
                      vSpace(15),
                      SizedBox(
                        height: FetchPixels.getPixelHeight(180),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Obx(
                            () => FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                  center: const LatLng(20.5937, 78.9629),
                                  zoom: 5,
                                  onTap: (_, p) {
                                    print(p);
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
                                  markers: [
                                    // Marker(
                                    //   point: LatLng(14.059274, 76.385020),
                                    //   builder: (context) => GestureDetector(
                                    //     onTap: () {},
                                    //     child: Image(
                                    //       image: AssetImage("home_marker".png),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
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
