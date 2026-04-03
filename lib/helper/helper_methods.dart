// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date/time formatting

String formatDate(Timestamp timestamp) {
  DateTime postDateTime = timestamp.toDate();
  DateTime now = DateTime.now();

  Duration difference = now.difference(postDateTime);

  if (difference.inMinutes < 1) {
    return 'just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else {
    return DateFormat('MMM d, y')
        .format(postDateTime); // Show date if > 1 day ago
  }
}
