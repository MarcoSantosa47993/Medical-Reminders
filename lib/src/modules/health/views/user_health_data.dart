import 'package:intl/intl.dart';

class UserHealthData {
  String label;
  int value;
  String unit;
  int quantity;
  int registDate;
  String? imageAsset;

  UserHealthData({
    required this.label,
    required this.value,
    required this.unit,
    required this.quantity,
    required this.registDate,
    this.imageAsset,
  });
}


int parseDateToMillis(String dateStr) {
  final dateFormat = DateFormat('dd/MM/yyyy');
  final dateTime = dateFormat.parse(dateStr);
  return dateTime.millisecondsSinceEpoch;
}

final List<UserHealthData> usersHealthData = [
  UserHealthData(
    label: 'Weight',
    value: 70,
    unit: 'kg',
    quantity: 1,
    registDate: parseDateToMillis('23/04/2025'),
    imageAsset: 'images/weight.jpg',
  ),
  UserHealthData(
    label: 'Height',
    value: 175,
    unit: 'cm',
    quantity: 1,
    registDate: parseDateToMillis('23/04/2025'),
    imageAsset: null,
  ),
  UserHealthData(
    label: 'Heart Rate',
    value: 70,
    unit: 'bpm',
    quantity: 1,
    registDate: parseDateToMillis('23/04/2025'),
    imageAsset: 'images/heartrate.png',
  ),
  UserHealthData(
    label: 'Blood Sugar',
    value: 154,
    unit: 'mg/dl',
    quantity: 1,
    registDate: parseDateToMillis('23/04/2025'),
    imageAsset: 'images/diabetes.png',
  ),
];
