import 'package:bloc/bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_medicins_event.dart';
part 'get_medicins_state.dart';

class GetMedicinsBloc extends Bloc<GetMedicinsEvent, GetMedicinsState> {
  final MedicinsRepository _medicinsRepository;

  GetMedicinsBloc(this._medicinsRepository)
    : super(GetMedicinsInitial()) {
    on<GetMedicins>((event, emit) async {
      emit(GetMedicinsLoading());
      try {
        final medicins = await _medicinsRepository.getMyMedicins();
        emit(GetMedicinsSuccess(medicins: medicins));
      } catch (e) {
        emit(GetMedicinsFailure());
      }
    });
  }
}
