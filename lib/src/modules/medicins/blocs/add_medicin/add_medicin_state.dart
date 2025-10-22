part of 'add_medicin_bloc.dart';

sealed class AddMedicinState extends Equatable {
  const AddMedicinState();

  @override
  List<Object> get props => [];
}

final class AddMedicinInitial extends AddMedicinState {}

final class AddMedicinLoading extends AddMedicinState {}

final class AddMedicinFailure extends AddMedicinState {}

final class AddMedicinSuccess extends AddMedicinState {}
