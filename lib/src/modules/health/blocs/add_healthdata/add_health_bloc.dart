import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health_repository/health_repository.dart';

part 'add_health_event.dart';
part 'add_health_state.dart';

class AddHealthBloc extends Bloc<AddHealthEvent, AddHealthState> {
  final HealthRepository _healthRepository;

  AddHealthBloc(this._healthRepository) : super(AddHealthInitial()) {
    on<AddHealth>((event, emit) async {
      try {
        emit(AddHealthLoading());

        await _healthRepository.addHealth(event.health);

        emit(AddHealthSuccess());
      } catch (e) {
        emit(AddHealthFailure());
      }
    });
  }
}
