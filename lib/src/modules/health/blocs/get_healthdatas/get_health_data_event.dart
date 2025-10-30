part of 'get_health_data_bloc.dart';

abstract class GetHealthDataEvent extends Equatable {
  const GetHealthDataEvent();

  @override
  List<Object> get props => [];
}

class GetHealthData extends GetHealthDataEvent {
  final DateTime date;

  const GetHealthData(this.date);
}