part of 'update_create_plan_bloc.dart';

sealed class UpdateCreatePlanState extends Equatable {
  const UpdateCreatePlanState();
  
  @override
  List<Object> get props => [];
}

final class UpdateCreatePlanInitial extends UpdateCreatePlanState {}
