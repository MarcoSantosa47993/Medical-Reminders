part of 'get_plans_bloc.dart';

sealed class GetPlansState extends Equatable {
  const GetPlansState();

  @override
  List<Object> get props => [];
}

final class GetPlansInitial extends GetPlansState {}

final class GetPlansLoading extends GetPlansState {}

final class GetPlansSuccess extends GetPlansState {
  final List<Planning> plans;

  const GetPlansSuccess({required this.plans});

  @override
  List<Object> get props => [plans];
}

final class GetPlansFailure extends GetPlansState {}
