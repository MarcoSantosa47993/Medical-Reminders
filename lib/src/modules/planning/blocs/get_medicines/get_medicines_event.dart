part of 'get_medicines_bloc.dart';

sealed class GetMedicinesEvent extends Equatable {
  const GetMedicinesEvent();

  @override
  List<Object> get props => [];
}

class GetMedicines extends GetMedicinesEvent {}
