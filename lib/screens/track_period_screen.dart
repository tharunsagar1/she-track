import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackPeriodScreen extends StatefulWidget {
  @override
  _TrackPeriodScreenState createState() => _TrackPeriodScreenState();
}

class _TrackPeriodScreenState extends State<TrackPeriodScreen> {
  final String userId = 'Sz97sXBfotczSSAChPSN'; // hardcoded for now
  List<DateTime> _periodDates = [];
  List<int> _intervals = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPeriodLogs();
  }

  Future<void> _fetchPeriodLogs() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('period_logs')
          .orderBy('startDate', descending: false)
          .get();

      final dates = snapshot.docs.map((doc) {
        Timestamp ts = doc['startDate'];
        return ts.toDate();
      }).toList();

      final intervals = <int>[];
      for (int i = 1; i < dates.length; i++) {
        final diff = dates[i].difference(dates[i - 1]).inDays;
        intervals.add(diff);
      }

      setState(() {
        _periodDates = dates;
        _intervals = intervals;
        _loading = false;
      });
    } catch (e) {
      print("Error fetching period logs: $e");
      setState(() => _loading = false);
    }
  }

  double get averageCycle {
    if (_intervals.isEmpty) return 0;
    return _intervals.reduce((a, b) => a + b) / _intervals.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Period Tracker"),
        backgroundColor: Colors.pink[300],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _periodDates.isEmpty
              ? Center(child: Text("No period logs found."))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_intervals.length > 1)
                        Text(
                          "Your average cycle is every ${averageCycle.toStringAsFixed(1)} days",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[800],
                          ),
                        ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _periodDates.length,
                          itemBuilder: (context, index) {
                            final date = _periodDates[index];
                            final interval = index == 0
                                ? null
                                : _periodDates[index]
                                    .difference(_periodDates[index - 1])
                                    .inDays;

                            return ListTile(
                              leading: Icon(Icons.calendar_today,
                                  color: Colors.pink[400]),
                              title: Text(DateFormat.yMMMMd().format(date)),
                              subtitle: interval != null
                                  ? Text("Interval: $interval days")
                                  : Text("First recorded period"),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
