part of 'get_medicines_bloc.dart';

sealed class GetMedicinesState extends Equatable {
  const GetMedicinesState();

  @override
  List<Object> get props => [];
}

final class GetMedicinesInitial extends GetMedicinesState {}

final class GetMedicinesLoading extends GetMedicinesState {}

final class GetMedicinesFailure extends GetMedicinesState {}

final class GetMedicinesSuccess extends GetMedicinesState {
  final List<Medicin> medicines;

  const GetMedicinesSuccess({required this.medicines});

  @override
  List<Object> get props => [medicines];
}
