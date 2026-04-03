import 'package:flutter/material.dart';

import 'Constants/colors.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: myMainColor,
            // Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        )),
      ),
    );
  }
}
