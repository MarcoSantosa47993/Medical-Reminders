part of 'get_medicin_bloc.dart';

sealed class GetMedicinEvent extends Equatable {
  const GetMedicinEvent();

  @override
  List<Object> get props => [];
}

class GetMedicin extends GetMedicinEvent {
  final String medicinId;

  const GetMedicin({required this.medicinId});

  @override
  List<Object> get props => [medicinId];
}

class SetMedicin extends GetMedicinEvent {
  final Medicin medicin;

  const SetMedicin({required this.medicin});

  @override
  List<Object> get props => [Medicin];
}

class AddMedicin extends GetMedicinEvent {
  final Medicin medicin;

  const AddMedicin({required this.medicin});

  @override
  List<Object> get props => [Medicin];
}

class RemoveMedicin extends GetMedicinEvent {
  final String medicinId;

  const RemoveMedicin({required this.medicinId});

  @override
  List<Object> get props => [medicinId];
}
