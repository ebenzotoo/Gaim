import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.bold)),
          Text(
            user,
            style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontSize: 11),
          ),
          SizedBox(
            height: 10,
          ),
          // Text(" . ",
          //     style: TextStyle(
          //         color: Theme.of(context).colorScheme.inversePrimary)),
          Text(time,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary, fontSize: 8)),
        ],
      ),
    );
  }
}
