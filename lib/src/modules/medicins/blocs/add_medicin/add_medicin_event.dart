part of 'add_medicin_bloc.dart';

sealed class AddMedicinEvent extends Equatable {
  const AddMedicinEvent();

  @override
  List<Object> get props => [];
}

class AddMedicin extends AddMedicinEvent {
  final Medicin medicin;

  const AddMedicin({required this.medicin});

  @override
  List<Object> get props => [medicin];
}