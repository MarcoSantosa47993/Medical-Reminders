part of 'add_dependent_bloc.dart';

sealed class AddDependentState extends Equatable {
  const AddDependentState();

  @override
  List<Object> get props => [];
}

final class AddDependentInitial extends AddDependentState {}

final class AddDependentLoading extends AddDependentState {}

final class AddDependentFailure extends AddDependentState {}

final class AddDependentSuccess extends AddDependentState {}
