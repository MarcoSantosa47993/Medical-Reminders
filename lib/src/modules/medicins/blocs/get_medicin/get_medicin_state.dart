part of 'get_medicin_bloc.dart';

sealed class GetMedicinState extends Equatable {
  const GetMedicinState();

  @override
  List<Object> get props => [];
}

final class GetMedicinInitial extends GetMedicinState {}

final class GetMedicinLoading extends GetMedicinState {}

final class GetMedicinFailure extends GetMedicinState {
  final GetMedicinType type;

  const GetMedicinFailure({required this.type});

  @override
  List<Object> get props => [type];
}

final class GetMedicinSuccess extends GetMedicinState {
  final Medicin? medicin;
  final GetMedicinType type;

  const GetMedicinSuccess({required this.medicin, required this.type});

  @override
  List<Object> get props => [type];
}

enum GetMedicinType { getMedicin, changeMedicin, removeMedicin }
