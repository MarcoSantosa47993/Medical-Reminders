part of 'get_dependent_bloc.dart';

sealed class GetDependentState extends Equatable {
  const GetDependentState();

  @override
  List<Object> get props => [];
}

final class GetDependentInitial extends GetDependentState {}

final class GetDependentLoading extends GetDependentState {}

final class GetDependentFailure extends GetDependentState {
  final GetDependentType type;

  const GetDependentFailure({required this.type});

  @override
  List<Object> get props => [type];
}

final class GetDependentSuccess extends GetDependentState {
  final Dependent? dependent;
  final GetDependentType type;

  const GetDependentSuccess({required this.dependent, required this.type});

  @override
  List<Object> get props => [type];
}

enum GetDependentType { getDependent, changeDependent, removeDependent }
