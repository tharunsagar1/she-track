import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final userId = 'Sz97sXBfotczSSAChPSN'; // You can use FirebaseAuth later

  Set<DateTime> _markedDates = {};

  @override
  void initState() {
    super.initState();
    _loadPeriodLogs();
  }

  Future<void> _loadPeriodLogs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('period_logs')
        .orderBy('startDate', descending: true)
        .get();

    final dates = snapshot.docs.map((doc) {
      Timestamp timestamp = doc['startDate'];
      DateTime date = timestamp.toDate();
      return DateTime(date.year, date.month, date.day); // Strip time
    }).toSet();

    setState(() {
      _markedDates = dates;
    });
  }

  bool _isMarked(DateTime day) {
    return _markedDates.contains(DateTime(day.year, day.month, day.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Calendar'),
        backgroundColor: Colors.pink[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.now(),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.pink.shade200,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.pink.shade400,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.redAccent,
              shape: BoxShape.circle,
            ),
            markerSizeScale: 1.5,
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (_isMarked(date)) {
                return Container(
                  margin: const EdgeInsets.only(top: 6.0),
                  width: 6.0,
                  height: 6.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
