import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'views/tela_um.dart';
import 'views/fast_track.dart';
import 'views/my_track.dart';
import 'views/user_trackings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Muambão',
      theme: themeController.themeData,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const TelaUm()),
        GetPage(name: '/fasttrack', page: () => FastTrack()),
        GetPage(name: '/newtrack', page: () => NewTrack()),
        GetPage(name: '/mytrack', page: () => const TrackingCodesScreen()),
      ],
    );
  }
}
