import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  ThemeData get themeData =>
      Get.isDarkMode ? ThemeData.dark() : ThemeData.light();
}
