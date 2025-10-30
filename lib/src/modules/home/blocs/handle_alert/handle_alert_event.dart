part of 'handle_alert_bloc.dart';

sealed class HandleAlertEvent extends Equatable {
  const HandleAlertEvent();

  @override
  List<Object> get props => [];
}

class HandleTakeMedicine extends HandleAlertEvent {
  final Planning plan;

  const HandleTakeMedicine(this.plan);

  @override
  List<Object> get props => [plan];
}

class HandleNotTakeMedicine extends HandleAlertEvent {
  final Planning plan;

  const HandleNotTakeMedicine(this.plan);

  @override
  List<Object> get props => [plan];
}