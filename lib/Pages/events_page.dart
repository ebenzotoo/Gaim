import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:godalone/Pages/SubPages/events_webview.dart';

import '../components/Constants/colors.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  Map<String, String> _nextSunday() {
    final now = DateTime.now();
    final daysUntil = (DateTime.sunday - now.weekday) % 7;
    final sunday = now.add(Duration(days: daysUntil == 0 ? 7 : daysUntil));
    return {
      'date': sunday.day.toString(),
      'month': _months[sunday.month - 1],
    };
  }

  @override
  Widget build(BuildContext context) {
    final nextSunday = _nextSunday();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Programs',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(10, 100),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
              child: CalendarTimeline(
                monthColor: Theme.of(context).colorScheme.primary,
                dayColor: myMainColor,
                activeDayColor: myMainColor,
                initialDate: DateTime.now(),
                firstDate: DateTime.utc(2010, 01, 01),
                selectableDayPredicate: (date) => date.day != 23,
                lastDate: DateTime.utc(2124, 12, 12),
                onDateSelected: (date) => setState(() {}),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return EventseWebview();
                    }));
                  },
                  child: makeItem(
                    image: 'assets/3.jpg',
                    date: nextSunday['date']!,
                    month: nextSunday['month']!,
                    venue: 'GAIM Sanctuary, Comm 18',
                    time: '8:00 am',
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Theme.of(context).colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          spreadRadius: 5,
                          blurRadius: 15,
                        )
                      ]),
                  child: const Center(
                    child: Text(
                      'Church Activities',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const ProgramsWidget(
                  day: 'Tuesday',
                  program: 'Bible Studies',
                  time: '7:00 pm',
                ),
                const SizedBox(height: 10),
                const ProgramsWidget(
                  day: 'Thursdays',
                  program: 'Prophetic Service',
                  time: '7:00 pm',
                ),
                const SizedBox(height: 10),
                const ProgramsWidget(
                  day: 'Fridays',
                  program: 'Testimony Hour',
                  time: '7:00 pm',
                ),
                const SizedBox(height: 10),
                const ProgramsWidget(
                  day: 'Saturdays',
                  program: 'Jabez Hour',
                  time: '7:00 am',
                ),
                const SizedBox(height: 10),
                const ProgramsWidget(
                  day: 'Sundays',
                  program: 'Glory Service',
                  time: '8:00 am',
                ),
                const SizedBox(height: 50),
              ],
            ),
          )),
        ));
  }

  Widget makeItem({
    required String image,
    required String date,
    required String month,
    required String venue,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 150,
          margin: const EdgeInsets.only(right: 20),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text(date,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                Text(month,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 150,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover)),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.black.withValues(alpha: 0.1),
                  ]),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    venue,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white),
                      Text(
                        time,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProgramsWidget extends StatelessWidget {
  final String day;
  final String program;
  final String time;

  const ProgramsWidget({
    super.key,
    required this.day,
    required this.program,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 60,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(image: AssetImage('assets/2.png'))),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              program,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
