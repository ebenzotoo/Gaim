import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:godalone/Pages/notification_page.dart';
import 'package:godalone/components/daily_scripture.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../bible/pages/bible_home_page.dart';
import '../components/Constants/colors.dart';
import '../components/Constants/padding.dart';
import '../components/my_drawer.dart';
import 'carousel_slider_page.dart';

class HomeViewPage extends StatefulWidget {
  const HomeViewPage({
    super.key,
  });

  @override
  State<HomeViewPage> createState() => _HomeViewPageState();
}

class _HomeViewPageState extends State<HomeViewPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String username = ''; // Variable to store the username
  bool _isLoading = true; // Loading state
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    fetchUsername(); // Fetch the username when the page initializes
  }

  void fetchUsername() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection(
            "users") // Ensure this matches your Firestore collection name
        .doc(currentUser.uid) // Use the user's UID to fetch their document
        .get();

    if (userDoc.exists) {
      final userData =
          userDoc.data() as Map<String, dynamic>?; // Cast data to Map
      setState(() {
        username = userData?['name'] ??
            currentUser.email!.split('@')[0]; // Access username
        _isLoading = false; // Set loading to false after fetching
      });
    } else {
      setState(() {
        username = currentUser.email!.split(
            '@')[0]; // Default to email prefix if user document doesn't exist
        _isLoading = false; // Set loading to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          title: _isLoading
              ? const CircularProgressIndicator() // Show loading indicator while fetching username
              : Text(
                  'Hi, $username',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
          actions: [
            IconButton(
                onPressed: () {
                  showBarModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const NotificationPage();
                      });
                },
                icon: const Icon(Icons.notifications_outlined)),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: const Padding(
                  padding: mywidgetPadding,
                  child: CarouselSliderPage(),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Card(
                    elevation: 10,
                    color: Theme.of(context).colorScheme.secondary,
                    child: const DailyScriptureScreen()),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              flex: 2,
              child: Padding(
                padding: mywidgetPadding,
                child: ListView(
                  children: [
                    const Padding(
                      padding: mywidgetPadding,
                      child: Text(
                        "GET IN TOUCH WITH US:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Card(
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                image: DecorationImage(
                                  image: AssetImage('assets/2.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "- www.godaloneint.org",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- +233240777905',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '- Devtraco Junction, Comm 18 - Tema, Ghana',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BibleHomePage(),
              ),
            );
          },
          backgroundColor: myMainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          elevation: 8,
          child: const Icon(
            Icons.menu_book_outlined,
            size: 30,
          ),
        ),
      ),
    );
  }
}
