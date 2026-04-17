import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_log.dart';
import '../models/period_log.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a health log
  Future<void> saveHealthLog(String userId, HealthLog log) async {
    final logRef = _db
        .collection('users')
        .doc(userId)
        .collection('healthLogs')
        .doc(log.date.toIso8601String());

    await logRef.set(log.toMap());
  }

  // Get all health logs
  Future<List<HealthLog>> getHealthLogs(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('healthLogs')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => HealthLog.fromMap(doc.data()))
        .toList();
  }

  // Save a period log
  Future<void> savePeriodLog(String userId, PeriodLog log) async {
    final logRef = _db
        .collection('users')
        .doc(userId)
        .collection('periodLogs')
        .doc(log.startDate.toIso8601String()); // unique ID based on startDate

    await logRef.set(log.toMap());
  }

  // Get all period logs
  Future<List<PeriodLog>> getPeriodLogs(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('periodLogs')
        .orderBy('startDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PeriodLog.fromMap(doc.data()))
        .toList();
  }
}
