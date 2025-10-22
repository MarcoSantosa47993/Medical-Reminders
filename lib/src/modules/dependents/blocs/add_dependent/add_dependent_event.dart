part of 'add_dependent_bloc.dart';

sealed class AddDependentEvent extends Equatable {
  const AddDependentEvent();

  @override
  List<Object> get props => [];
}

class AddDependent extends AddDependentEvent {
  final int pinCode;

  const AddDependent({required this.pinCode});

  @override
  List<Object> get props => [pinCode];
}
