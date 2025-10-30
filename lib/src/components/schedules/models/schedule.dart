class Schedule {
  final DateTime takeAt;
  final String medicinName;
  final ScheduleStatus status;

  Schedule(this.takeAt, this.medicinName, this.status);

  static final data = [
    Schedule(DateTime(2024, 9, 7, 9, 00), "Brufen", ScheduleStatus.taken),
    Schedule(
      DateTime(2024, 9, 7, 10, 00),
      "Paracetamol",
      ScheduleStatus.notTaken,
    ),
    Schedule(DateTime(2024, 9, 7, 11, 00), "Aspirine", ScheduleStatus.pending),
    Schedule(DateTime(2024, 9, 7, 12, 00), "Benurom", ScheduleStatus.scheduled),
  ];
}

enum ScheduleStatus { taken, notTaken, pending, scheduled }
