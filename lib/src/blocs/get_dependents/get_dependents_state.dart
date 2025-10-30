part of 'get_dependents_bloc.dart';

sealed class GetDependentsState extends Equatable {
  const GetDependentsState();

  @override
  List<Object> get props => [];
}

final class GetDependentsInitial extends GetDependentsState {}

final class GetDependentsLoading extends GetDependentsState {}

final class GetDependentsFailure extends GetDependentsState {}

final class GetDependentsSuccess extends GetDependentsState {
  final List<Dependent> dependents;

  const GetDependentsSuccess({required this.dependents});

  @override
  List<Object> get props => [dependents];
}
