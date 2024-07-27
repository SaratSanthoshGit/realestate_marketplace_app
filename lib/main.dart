import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'utils/manager/font_manager.dart';


void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await GetStorage.init();
  // await Firebase.initializeApp( // TODO - UnComment this line once firebase connected.
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  Future.delayed(const Duration(seconds: 1), () {
    FlutterNativeSplash.remove();
  });
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final GetStorage box = GetStorage();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    fetchPixels(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Caves Real Estate",
      initialBinding: BindingsBuilder(() => {}),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: fontNunito,
      ),
      home: (box.read("isSkipped") ?? false) ? Dashboard() : OnBoardingPage(),
    );
  }

  void fetchPixels(BuildContext context) {
    // Your implementation of the 'FetchPixels' method goes here
  }
}
