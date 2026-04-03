import 'package:flutter/material.dart';

import 'Constants/colors.dart';

class MyListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyListTile(
      {super.key, required this.onTap, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: myMainColor,
        ),
        onTap: onTap,
        title: Text(
          text,
          style:
              const TextStyle(color: myMainColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
