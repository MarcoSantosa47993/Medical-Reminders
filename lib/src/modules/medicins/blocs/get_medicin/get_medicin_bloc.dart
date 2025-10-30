import 'package:bloc/bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_medicin_event.dart';
part 'get_medicin_state.dart';

class GetMedicinBloc extends Bloc<GetMedicinEvent, GetMedicinState> {
  final MedicinsRepository _medicinsRepository;

  GetMedicinBloc(this._medicinsRepository) : super(GetMedicinInitial()) {
    on<GetMedicin>((event, emit) async {
      emit(GetMedicinLoading());
      try {
        final medicin = await _medicinsRepository.getMedicin(
          event.medicinId,
        );
        emit(
          GetMedicinSuccess(
            medicin: medicin,
            type: GetMedicinType.getMedicin,
          ),
        );
      } catch (e) {
        emit(GetMedicinFailure(type: GetMedicinType.getMedicin));
      }
    });

    on<SetMedicin>((event, emit) async {
      emit(GetMedicinLoading());
      try {
        await _medicinsRepository.setMedicin(event.medicin);
        final medicin = await _medicinsRepository.getMedicin(
          event.medicin.id,
        );
        emit(
          GetMedicinSuccess(
            medicin: medicin,
            type: GetMedicinType.changeMedicin,
          ),
        );
      } catch (e) {
        emit(GetMedicinFailure(type: GetMedicinType.changeMedicin));
      }
    });

    on<AddMedicin>((event, emit) async {
      emit(GetMedicinLoading());
      try {
        await _medicinsRepository.addMedicin(event.medicin);
        final medicin = await _medicinsRepository.getMedicin(
          event.medicin.id,
        );
        emit(
          GetMedicinSuccess(
            medicin: medicin,
            type: GetMedicinType.changeMedicin,
          ),
        );
      } catch (e) {
        emit(GetMedicinFailure(type: GetMedicinType.changeMedicin));
      }
    });

    on<RemoveMedicin>((event, emit) async {
      emit(GetMedicinLoading());
      try {
        await _medicinsRepository.removeMedicin(event.medicinId);
        emit(
          GetMedicinSuccess(
            medicin: null,
            type: GetMedicinType.removeMedicin,
          ),
        );
      } catch (e) {
        emit(GetMedicinFailure(type: GetMedicinType.removeMedicin));
      }
    });
  }
}
