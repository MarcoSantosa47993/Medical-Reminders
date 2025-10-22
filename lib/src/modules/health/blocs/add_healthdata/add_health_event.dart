part of 'add_health_bloc.dart';

abstract class AddHealthEvent extends Equatable {
  const AddHealthEvent();

  @override
  List<Object> get props => [];
}

class AddHealth extends AddHealthEvent {
  final Health health;

  const AddHealth({required this.health});

  @override
  List<Object> get props => [health];
}