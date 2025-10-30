part of 'get_dependent_bloc.dart';

sealed class GetDependentEvent extends Equatable {
  const GetDependentEvent();

  @override
  List<Object> get props => [];
}

class GetDependent extends GetDependentEvent {
  final String dependentId;

  const GetDependent({required this.dependentId});

  @override
  List<Object> get props => [dependentId];
}

class SetDependent extends GetDependentEvent {
  final Dependent dependent;

  const SetDependent({required this.dependent});

  @override
  List<Object> get props => [dependent];
}

class RemoveDependent extends GetDependentEvent {
  final String dependentId;

  const RemoveDependent({required this.dependentId});

  @override
  List<Object> get props => [dependentId];
}
