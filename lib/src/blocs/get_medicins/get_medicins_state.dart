part of 'get_medicins_bloc.dart';

sealed class GetMedicinsState extends Equatable {
  const GetMedicinsState();

  @override
  List<Object> get props => [];
}

final class GetMedicinsInitial extends GetMedicinsState {}

final class GetMedicinsLoading extends GetMedicinsState {}

final class GetMedicinsFailure extends GetMedicinsState {}

final class GetMedicinsSuccess extends GetMedicinsState {
  final List<Medicin> medicins;

  const GetMedicinsSuccess({required this.medicins});

  @override
  List<Object> get props => [medicins];
}
