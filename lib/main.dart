import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godalone/auth/auth.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';
import 'package:provider/provider.dart';
import 'Pages/home_view_page.dart';
import 'bible/models/verse.dart';
import 'bible/providers/main_provider.dart';
import 'bible/services/fetch_books.dart';
import 'bible/services/fetch_verses.dart';
import 'bible/services/save_current_index.dart';
import 'components/Constants/colors.dart';
import 'firebase_options.dart';
import 'pages/community_page.dart';
import 'pages/events_page.dart';
import 'pages/profile_page.dart';
import 'pages/sermon_and_live_toggle.dart';
import 'themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      // ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ChangeNotifierProvider(create: (context) => MainProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final mainProvider = Provider.of<MainProvider>(context, listen: false);
      mainProvider.itemPositionsListener.itemPositions.addListener(
        () {
          final int index = mainProvider
              .itemPositionsListener.itemPositions.value.last.index;

          SaveCurrentIndex.execute(
              index: mainProvider
                  .itemPositionsListener.itemPositions.value.first.index);

          final Verse currentVerse = mainProvider.verses[index];

          if (mainProvider.currentVerse == null) {
            mainProvider.updateCurrentVerse(verse: mainProvider.verses.first);
          }

          final Verse previousVerse = mainProvider.currentVerse == null
              ? mainProvider.verses.first
              : mainProvider.currentVerse!;

          if (currentVerse.book != previousVerse.book) {
            mainProvider.updateCurrentVerse(verse: currentVerse);
          }
        },
      );
      await FetchVerses.execute(mainProvider: mainProvider);
      await FetchBooks.execute(mainProvider: mainProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GodALone Int Min',
      home: const AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

class TabViewPage extends StatefulWidget {
  final int initialIndex;
  const TabViewPage({super.key, this.initialIndex = 0});

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage>
    with SingleTickerProviderStateMixin {
  late MotionTabBarController _motionTabBarController;

  @override
  void initState() {
    _motionTabBarController = MotionTabBarController(
      length: 5,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _motionTabBarController.index = widget.initialIndex;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        body: TabBarView(
            controller: _motionTabBarController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeViewPage(),
              SermonLiveToggle(),
              EventsPage(),
              CommunityPage(),
              ProfilePage()
            ]),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  MotionTabBar _buildBottomNavigationBar() {
    return MotionTabBar(
      controller: _motionTabBarController,
      initialSelectedTab: _getTabName(widget.initialIndex),
      labels: const [
        "Home",
        "Live",
        "Programs",
        "Comm",
        "Profile",
      ],
      icons: const [
        Icons.home,
        Icons.live_tv_outlined,
        Icons.calendar_view_month,
        Icons.groups_3_outlined,
        Icons.person_2_outlined
      ],
      tabSize: 50,
      tabBarHeight: 55,
      textStyle: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
      tabIconColor: Colors.grey.shade400,
      tabIconSize: 28.0,
      tabIconSelectedSize: 26.0,
      tabSelectedColor: myMainColor,
      tabIconSelectedColor: Colors.white,
      tabBarColor: Theme.of(context).colorScheme.surface,
      onTabItemSelected: (int value) {
        setState(() {
          _motionTabBarController.index = value;
        });
      },
    );
  }

  String _getTabName(int index) {
    switch (index) {
      case 1:
        return "Live";
      case 2:
        return "Events";
      case 3:
        return "Comm";
      case 4:
        return "Profile";
      default:
        return "Home";
    }
  }
}
