part of 'get_plans_bloc.dart';

sealed class GetPlansEvent extends Equatable {
  const GetPlansEvent();

  @override
  List<Object> get props => [];
}

class GetPlans extends GetPlansEvent {
  final DateTime date;

  const GetPlans(this.date);
}
