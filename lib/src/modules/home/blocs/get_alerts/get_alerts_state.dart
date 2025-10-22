part of 'get_alerts_bloc.dart';

sealed class GetAlertsState extends Equatable {
  const GetAlertsState();

  @override
  List<Object> get props => [];
}

final class GetAlertsInitial extends GetAlertsState {}

final class GetAlertsLoading extends GetAlertsState {}

final class GetAlertsSuccess extends GetAlertsState {
  final List<Planning> plans;

  const GetAlertsSuccess(this.plans);

  @override
  List<Object> get props => [plans];
}

final class GetAlertsFailure extends GetAlertsState {}