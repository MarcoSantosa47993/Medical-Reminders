part of 'get_medicins_bloc.dart';

sealed class GetMedicinsEvent extends Equatable {
  const GetMedicinsEvent();

  @override
  List<Object> get props => [];
}

class GetMedicins extends GetMedicinsEvent {}