import 'package:flutter/material.dart';

import '../../pages/SubPages/give.dart';

void showGiveModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => const Give(isBottomSheet: true),
  );
}
