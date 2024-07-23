import 'package:flutter/material.dart';

class NewAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nometela;

  NewAppBar({required this.nometela});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(nometela),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
