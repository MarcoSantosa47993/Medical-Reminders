part of 'get_dependents_bloc.dart';

sealed class GetDependentsEvent extends Equatable {
  const GetDependentsEvent();

  @override
  List<Object> get props => [];
}

class GetDependents extends GetDependentsEvent {}
