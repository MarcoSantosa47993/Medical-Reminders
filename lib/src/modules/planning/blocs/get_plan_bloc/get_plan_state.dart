part of 'get_plan_bloc.dart';

sealed class GetPlanState extends Equatable {
  const GetPlanState();

  @override
  List<Object> get props => [];
}

final class GetPlanInitial extends GetPlanState {}

final class GetPlanLoading extends GetPlanState {}

final class GetPlanFailure extends GetPlanState {
  final GetPlanType type;
  final String? message;

  const GetPlanFailure({required this.type, required this.message});

  @override
  List<Object> get props => [type];
}

final class GetPlanSuccess extends GetPlanState {
  final Planning plan;
  final GetPlanType type;
  final String? errorMessage;

  const GetPlanSuccess({
    required this.plan,
    required this.type,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [type];
}

enum GetPlanType { getPlan, changePlan, removePlan, addPlan }