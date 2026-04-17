import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogPeriodScreen extends StatefulWidget {
  @override
  _LogPeriodScreenState createState() => _LogPeriodScreenState();
}

class _LogPeriodScreenState extends State<LogPeriodScreen> {
  DateTime? _selectedDate;
  bool _isSaving = false;

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _savePeriodLog() async {
  if (_selectedDate == null) return;

  setState(() => _isSaving = true);

  final userId = 'Sz97sXBfotczSSAChPSN'; // hardcoded for now

  try {
    print("Trying to save: $_selectedDate");

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('period_logs')
        .add({
      'startDate': Timestamp.fromDate(_selectedDate!),
      'createdAt': Timestamp.now(),
    });

    print("Saved successfully");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved!")),
    );

    Navigator.pop(context);
  } on FirebaseException catch (e) {
    print("FirebaseException: ${e.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Firebase error: ${e.message}")),
    );
  } catch (e) {
    print("Generic error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  } finally {
    setState(() => _isSaving = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Period"),
        backgroundColor: Colors.pink[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Select the start date of your period:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.date_range),
              label: Text(
                _selectedDate == null
                    ? "Pick a date"
                    : "${_selectedDate!.toLocal()}".split(' ')[0],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _savePeriodLog,
                    child: const Text("Save Period Log"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
