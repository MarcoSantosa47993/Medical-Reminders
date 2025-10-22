part of 'handle_alert_bloc.dart';

sealed class HandleAlertState extends Equatable {
  const HandleAlertState();

  @override
  List<Object> get props => [];
}

final class HandleAlertInitial extends HandleAlertState {}

final class HandleAlertLoading extends HandleAlertState {}

final class HandleAlertFailure extends HandleAlertState {}

final class HandleAlertSuccess extends HandleAlertState {}