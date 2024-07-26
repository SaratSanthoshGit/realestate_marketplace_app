import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realestate_marketplace_app/screens/login/vm_login.dart';
import 'package:realestate_marketplace_app/utils/manager/font_manager.dart';
import 'package:realestate_marketplace_app/utils/resizer/fetch_pixels.dart';
import 'package:realestate_marketplace_app/widget/buttons/primary_button.dart';

import '../../utils/manager/color_manager.dart';
import '../../widget/widget_utils.dart';
import '../textbox/first_textbox.dart';

class LoginScreen extends StatelessWidget {
  final Function? onDone;

  LoginScreen({super.key, this.onDone});

  RxBool selectedTab = RxBool(true);

  @override
  Widget build(BuildContext context) {
    final data = Get.find<VMLogin>();
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 35, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: FetchPixels.getPixelWidth(20),
                ),
                child: Form(
                  key: data.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: getCustomFont(
                              "Welcome",
                              22,
                              Colors.black,
                              1,
                              fontWeight: bold,
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => AnimatedToggleSwitch<bool>.size(
                                current: selectedTab.value,
                                values: const [true, false],
                                indicatorSize:
                                    const Size.fromWidth(double.infinity),
                                customIconBuilder: (context, local, global) =>
                                    Text(
                                  (local.value ? 'Login' : 'Sign Up').tr,
                                  style: TextStyle(
                                    color: Color.lerp(
                                      Colors.black,
                                      Colors.black,
                                      local.animationValue,
                                    ),
                                    fontSize: 15,
                                  ),
                                ),
                                borderWidth: 5.0,
                                iconAnimationType: AnimationType.onSelected,
                                style: ToggleStyle(
                                  indicatorColor: white,
                                  backgroundColor: const Color(0xFFebebec),
                                  borderColor: Colors.transparent,
                                  borderRadius: BorderRadius.circular(13.0),
                                ),
                                selectedIconScale: 1.0,
                                height: 45,
                                onChanged: (b) {
                                  selectedTab.value = b;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FirstTextBox(
                        data: data.emailId,
                      ),
                      Obx(
                        () => selectedTab.value
                            ? Container()
                            : Column(
                                children: [
                                  vSpace(16),
                                  FirstTextBox(
                                    data: data.name,
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 16),
                      FirstTextBox(
                        data: data.password,
                        obscureText: true,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => PrimaryButton(
                                !selectedTab.value ? "Sign Up" : "Login",
                                radius: 10,
                                onTap: () {
                                  if (!selectedTab.value) {
                                    data.signUp();
                                  } else {
                                    data.login();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

openSignInAlert({Function? onDone}) async {
  await Get.bottomSheet(
    LoginScreen(onDone: onDone),
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.30),
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(24),
    //     topRight: Radius.circular(24),
    //   ),
    // ),
    isDismissible: true,
    isScrollControlled: true,
  );
}
