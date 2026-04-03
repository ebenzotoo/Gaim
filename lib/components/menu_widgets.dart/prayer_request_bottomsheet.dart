import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../pages/SubPages/prayer_request_page.dart';

void showPrayerRequestModalBottomSheet(BuildContext context) {
  showBarModalBottomSheet(
    context: context,
    builder: (context) {
      return const PrayerRequestPage();
    },
  );
}
