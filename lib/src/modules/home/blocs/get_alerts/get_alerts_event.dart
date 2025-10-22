part of 'get_alerts_bloc.dart';

sealed class GetAlertsEvent extends Equatable {
  const GetAlertsEvent();

  @override
  List<Object> get props => [];
}

class GetAlerts extends GetAlertsEvent {}