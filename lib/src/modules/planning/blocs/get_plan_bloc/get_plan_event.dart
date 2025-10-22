part of 'get_plan_bloc.dart';

sealed class GetPlanEvent extends Equatable {
  const GetPlanEvent();

  @override
  List<Object> get props => [];
}

class GetPlan extends GetPlanEvent {
  final String planId;

  const GetPlan(this.planId);

  @override
  List<Object> get props => [planId];
}

class SetPlan extends GetPlanEvent {
  final Planning plan;

  const SetPlan(this.plan);

  @override
  List<Object> get props => [plan];
}

class RemovePlan extends GetPlanEvent {
  final String planId;
  final String medicineId;

  const RemovePlan(this.planId, this.medicineId);

  @override
  List<Object> get props => [planId];
}

class NewPlan extends GetPlanEvent {
  final Planning plan;

  const NewPlan({required this.plan});

  @override
  List<Object> get props => [plan];
}
