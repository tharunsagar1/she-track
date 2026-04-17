class HealthLog {
  final DateTime date;
  final String mood;
  final int waterIntake;
  final String sleepDuration;
  final int exerciseMinutes;
  final String? nutrition;
  final Map<String, bool>? symptoms;

  HealthLog({
    required this.date,
    required this.mood,
    required this.waterIntake,
    required this.sleepDuration,
    required this.exerciseMinutes,
    this.nutrition,
    this.symptoms,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'mood': mood,
      'waterIntake': waterIntake,
      'sleepDuration': sleepDuration,
      'exerciseMinutes': exerciseMinutes,
      'nutrition': nutrition,
      'symptoms': symptoms,
    };
  }

  factory HealthLog.fromMap(Map<String, dynamic> map) {
    return HealthLog(
      date: DateTime.parse(map['date']),
      mood: map['mood'],
      waterIntake: map['waterIntake'],
      sleepDuration: map['sleepDuration'],
      exerciseMinutes: map['exerciseMinutes'],
      nutrition: map['nutrition'],
      symptoms: Map<String, bool>.from(map['symptoms'] ?? {}),
    );
  }
}
