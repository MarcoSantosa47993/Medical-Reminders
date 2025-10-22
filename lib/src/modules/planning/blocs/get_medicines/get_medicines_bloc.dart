import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medicins_repository/medicins_repository.dart';

part 'get_medicines_event.dart';
part 'get_medicines_state.dart';

class GetMedicinesBloc extends Bloc<GetMedicinesEvent, GetMedicinesState> {
  final MedicinsRepository _medicinsRepository;

  GetMedicinesBloc(this._medicinsRepository) : super(GetMedicinesInitial()) {
    on<GetMedicines>((event, emit) async {
      try {
        emit(GetMedicinesLoading());
        final medicines = await _medicinsRepository.getMyMedicins();
        emit(GetMedicinesSuccess(medicines: medicines));
      } catch (e) {
        emit(GetMedicinesFailure());
      }
    });
  }
}
