import 'package:medicins_repository/medicins_repository.dart';

class MedicinPurchaseInput {
  String name;
  String type;
  int quantityPurchased;
  int dosePerPeriod;
  Period period;
  String observations;

  MedicinPurchaseInput({
    required this.name,
    required this.type,
    required this.quantityPurchased,
    required this.dosePerPeriod,
    required this.period,
    required this.observations,
  });
}
