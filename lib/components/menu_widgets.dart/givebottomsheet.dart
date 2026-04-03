import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../pages/SubPages/give.dart';

void showGiveModalBottomSheet(BuildContext context) {
  showBarModalBottomSheet(
    context: context,
    builder: (context) {
      return const Give();
    },
  );
}
