import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewNavBar extends StatelessWidget {
  final List<Widget> tabs;

  const NewNavBar({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      onTap: (index) {
        Get.toNamed('/tab$index');
      },
    );
  }
}
