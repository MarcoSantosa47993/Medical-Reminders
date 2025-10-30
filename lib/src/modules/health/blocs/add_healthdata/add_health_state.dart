part of 'add_health_bloc.dart';

abstract class AddHealthState extends Equatable {
  const AddHealthState();

  @override
  List<Object> get props => [];
}

class AddHealthInitial extends AddHealthState {}

class AddHealthLoading extends AddHealthState {}

class AddHealthSuccess extends AddHealthState {}

class AddHealthFailure extends AddHealthState {}
