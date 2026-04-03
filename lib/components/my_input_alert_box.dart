import 'package:flutter/material.dart';

import 'Constants/colors.dart';

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintext;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox(
      {super.key,
      required this.textController,
      required this.hintext,
      required this.onPressed,
      required this.onPressedText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: textController,
        maxLength: 250,
        maxLines: 3,
        decoration: InputDecoration(
            // enabledBorder: OutlineInputBorder(
            //     borderSide:
            //         BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            // focusedBorder: OutlineInputBorder(
            //     borderSide:
            //         BorderSide(color: Theme.of(context).colorScheme.primary),
            //     borderRadius: BorderRadius.circular(12)),
            hintText: hintext,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            counterStyle:
                TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
      actions: [
        //cancel
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
              // onPressed!();
            },
            child: const Text('Cancel')),

        //save
        TextButton(
            onPressed: () {
              //close box
              Navigator.pop(context);

              //execute function
              onPressed!();

              //clear text
              textController.clear();
            },
            child: Text(onPressedText))
      ],
    );
  }
}

class MyPostMessageBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintext;
  final void Function()? onPressed;
  final String onPressedText;

  const MyPostMessageBox(
      {super.key,
      required this.textController,
      required this.hintext,
      required this.onPressed,
      required this.onPressedText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
              // onPressed!();
            },
            child: const Text('Cancel')),
        leadingWidth: 100,
        actions: [
          TextButton(
              onPressed: () {
                //close box
                Navigator.pop(context);

                //execute function
                onPressed!();

                //clear text
                textController.clear();
              },
              child: Text(
                onPressedText,
                style: const TextStyle(color: myMainColor),
              ))
        ],
      ),
      body: TextField(
        controller: textController,
        maxLength: 250,
        maxLines: 3,
        decoration: InputDecoration(
            // enabledBorder: OutlineInputBorder(
            //     borderSide:
            //         BorderSide(color: Theme.of(context).colorScheme.tertiary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12)),
            hintText: hintext,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            fillColor: Theme.of(context).colorScheme.secondary,
            filled: true,
            counterStyle:
                TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
    )

        // AlertDialog(
        //   shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(8),
        //     ),
        //   ),
        //   backgroundColor: Theme.of(context).colorScheme.surface,
        //   content: TextField(
        //     controller: textController,
        //     maxLength: 250,
        //     maxLines: 3,
        //     decoration: InputDecoration(
        //         enabledBorder: OutlineInputBorder(
        //             borderSide:
        //                 BorderSide(color: Theme.of(context).colorScheme.tertiary)),
        //         focusedBorder: OutlineInputBorder(
        //             borderSide:
        //                 BorderSide(color: Theme.of(context).colorScheme.primary),
        //             borderRadius: BorderRadius.circular(12)),
        //         hintText: hintext,
        //         hintStyle: TextStyle(
        //           color: Theme.of(context).colorScheme.primary,
        //         ),
        //         fillColor: Theme.of(context).colorScheme.secondary,
        //         filled: true,
        //         counterStyle:
        //             TextStyle(color: Theme.of(context).colorScheme.primary)),
        //   ),
        //   actions: [
        //     //cancel
        //     TextButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //           textController.clear();
        //           // onPressed!();
        //         },
        //         child: const Text('Cancel')),

        //     //save
        //     TextButton(
        //         onPressed: () {
        //           //close box
        //           Navigator.pop(context);

        //           //execute function
        //           onPressed!();

        //           //clear text
        //           textController.clear();
        //         },
        //         child: Text(onPressedText))
        //   ],
        // );
        ;
  }
}
