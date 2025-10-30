import 'package:dependents_repository/dependents_repository.dart';

abstract class DependentsRepository {
  Future<List<Dependent>> getMyDependents();

  Future<void> setDependent(Dependent dependent);

  Future<void> removeDependent(String dependentId);

  Future<void> addDependent(int pinCode);

  Future<Dependent> getDependent(String dependentId);
}
