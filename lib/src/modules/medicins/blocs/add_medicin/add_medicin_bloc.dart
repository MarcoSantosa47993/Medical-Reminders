import 'package:bloc/bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:equatable/equatable.dart';

part 'add_medicin_event.dart';
part 'add_medicin_state.dart';

class AddMedicinBloc extends Bloc<AddMedicinEvent, AddMedicinState> {
  final MedicinsRepository _medicinsRepository;

  AddMedicinBloc(this._medicinsRepository) : super(AddMedicinInitial()) {
    on<AddMedicin>((event, emit) async {
      try {
        emit(AddMedicinLoading());

        await _medicinsRepository.addMedicin(event.medicin);

        emit(AddMedicinSuccess());
      } catch (e) {
        emit(AddMedicinFailure());
      }
    });
  }
}