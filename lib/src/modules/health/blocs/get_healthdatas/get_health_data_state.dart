part of 'get_health_data_bloc.dart';

abstract class GetHealthDataState extends Equatable {
  const GetHealthDataState();

  @override
  List<Object?> get props => [];
}

class GetHealthDataInitial extends GetHealthDataState {}

class GetHealthDataLoading extends GetHealthDataState {}

class GetHealthDataSuccess extends GetHealthDataState {
  final List<Health> healthData;

  const GetHealthDataSuccess({required this.healthData});

  @override
  List<Object?> get props => [healthData];
}

class GetHealthDataFailure extends GetHealthDataState {}
