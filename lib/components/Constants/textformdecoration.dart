import 'package:flutter/material.dart';

// strings
class MyTextDecoration {
  static InputDecoration decorate({
    required String labelText,
    required IconData icon,
  }) {
    return InputDecoration(
      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      filled: true,
      fillColor: const Color.fromARGB(26, 97, 95, 95),
      prefixIcon: Icon(icon),
      labelText: labelText,
    );
  }
}

// passwords
class MyHiddenTextDecoration {
  static InputDecoration decorate({
    required String labelText,
    required IconData icon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
  }) {
    return InputDecoration(
      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      filled: true,
      fillColor: const Color.fromARGB(26, 97, 95, 95),
      prefixIcon: Icon(icon),
      labelText: labelText,
      suffixIcon: suffixIcon != null
          ? IconButton(onPressed: onSuffixIconPressed, icon: Icon(suffixIcon))
          : null,
    );
  }
}

// description
class MyLongTextDecoration {
  static InputDecoration decorate({
    required String labelText,
  }) {
    return InputDecoration(
      alignLabelWithHint: true,
      border: InputBorder.none,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      filled: true,
      fillColor: Colors.transparent,
      labelText: labelText,
    );
  }
}
