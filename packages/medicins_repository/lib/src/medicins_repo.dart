import 'package:medicins_repository/medicins_repository.dart';

abstract class MedicinsRepository {
  Future<List<Medicin>> getMyMedicins();

  Future<void> setMedicin(Medicin medicin);

  Future<void> removeMedicin(String medicinId);

  Future<void> addMedicin(Medicin medicin);

  Future<Medicin> getMedicin(String medicinId);

  Future<void> updateStock(String medicineId, {int value});
}
