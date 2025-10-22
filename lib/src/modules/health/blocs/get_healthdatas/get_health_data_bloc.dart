import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health_repository/health_repository.dart';

part 'get_health_data_event.dart';
part 'get_health_data_state.dart';

class GetHealthDataBloc extends Bloc<GetHealthDataEvent, GetHealthDataState> {
  final HealthRepository _healthRepository;

  GetHealthDataBloc(this._healthRepository) : super(GetHealthDataInitial()) {
    on<GetHealthData>((event, emit) async {
      emit(GetHealthDataLoading());
      try {
        final healthData = await _healthRepository.getMyHealth(event.date);
        emit(GetHealthDataSuccess(healthData: healthData));
      } catch (e) {
        emit(GetHealthDataFailure());
      }
    });
  }
}