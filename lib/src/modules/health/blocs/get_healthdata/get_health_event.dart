part of 'get_health_bloc.dart';

abstract class GetHealthEvent extends Equatable {
  const GetHealthEvent();

  @override
  List<Object> get props => [];
}

class GetHealth extends GetHealthEvent {
  final String healthId;

  const GetHealth(this.healthId);

  @override
  List<Object> get props => [healthId];
}

class SetHealth extends GetHealthEvent {
  final Health health;
  final Uint8List? image;

  const SetHealth(this.health, {this.image});

  @override
  List<Object> get props => [health];
}

class AddHealth extends GetHealthEvent {
  final Health health;
  final Uint8List? image;

  const AddHealth(this.health, {this.image});

  @override
  List<Object> get props => [health];
}

class RemoveHealth extends GetHealthEvent {
  final String healthId;

  const RemoveHealth(this.healthId);

  @override
  List<Object> get props => [healthId];
}