// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:godalone/Pages/SubPages/evangelism.dart';
import 'package:godalone/Pages/SubPages/prayer_request_page.dart';
import 'package:godalone/main.dart';
import '../auth/login_or_register.dart';
import 'Constants/colors.dart';
import 'menu_widgets.dart/givebottomsheet.dart';
import 'my_listtile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          const DrawerHeader(
              child: Icon(
            Icons.person,
            size: 64,
            color: myMainColor,
          )),
          MyListTile(
              icon: Icons.video_library_outlined,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TabViewPage(
                      initialIndex: 1,
                    ),
                  ),
                );
              },
              text: 'SERMONS'),
          MyListTile(
              icon: Icons.clean_hands,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Evangelism();
                }));
              },
              text: 'EVANGELISM'),
          MyListTile(
              icon: Icons.mobile_friendly,
              onTap: () {
                Navigator.pop(context);
                showGiveModalBottomSheet(context);
              },
              text: 'GIVE'),
          MyListTile(
              icon: Icons.request_page,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PrayerRequestPage();
                }));
              },
              text: 'PRAYER REQUESTS'),
          const Spacer(),
          // MyListTile(icon: Icons.logout, onTap: logOut, text: 'LOG OUT'),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: logOut,
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
