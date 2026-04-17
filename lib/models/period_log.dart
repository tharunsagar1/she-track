class PeriodLog {
  final DateTime startDate;
  final DateTime endDate;
  final String notes;

  PeriodLog({
    required this.startDate,
    required this.endDate,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory PeriodLog.fromMap(Map<String, dynamic> map) {
    return PeriodLog(
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      notes: map['notes'] ?? '',
    );
  }
}
