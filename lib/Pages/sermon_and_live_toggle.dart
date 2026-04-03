import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'live_prayerpage.dart';
import 'sermonpage.dart';

class SermonLiveToggle extends StatefulWidget {
  const SermonLiveToggle({super.key});

  @override
  State<SermonLiveToggle> createState() => _SermonLiveToggleState();
}

class _SermonLiveToggleState extends State<SermonLiveToggle> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final selectedTextStyle =
        textStyle?.copyWith(fontWeight: FontWeight.bold, fontSize: 15);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size(50, 30),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedTabControl(
                  tabTextColor: Colors.black45,
                  selectedTabTextColor: Colors.black,
                  textStyle: textStyle,
                  selectedTextStyle: selectedTextStyle,
                  tabPadding: const EdgeInsets.symmetric(horizontal: 8),
                  height: 45,
                  squeezeIntensity: 2,
                  barDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey.shade300,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        )
                      ]),
                  indicatorDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: const Color.fromARGB(255, 245, 244, 244),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                        )
                      ]),
                  tabs: const [
                    SegmentTab(label: 'Sermons'),
                    SegmentTab(label: 'Live Service'),
                  ]),
            ),
          ),
        ),
        body: const SafeArea(
            child: TabBarView(children: [SermonPage(), PrayerPage()])),
      ),
    );
  }
}
