part of 'get_health_bloc.dart';

enum GetHealthType { getHealth, changeHealth, removeHealth, addHealth }

abstract class GetHealthState extends Equatable {
  const GetHealthState();

  @override
  List<Object?> get props => [];
}

class GetHealthInitial extends GetHealthState {}

class GetHealthLoading extends GetHealthState {}

class GetHealthSuccess extends GetHealthState {
  final Health health;
  final GetHealthType type;
  final String? errorMessage;

  const GetHealthSuccess({
    required this.health,
    required this.type,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [health, type];
}

class GetHealthFailure extends GetHealthState {
  final GetHealthType type;
  final String? message;

  const GetHealthFailure({required this.type, required this.message});

  @override
  List<Object?> get props => [type];
}