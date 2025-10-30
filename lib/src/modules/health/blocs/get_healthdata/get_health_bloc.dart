import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health_repository/health_repository.dart';

part 'get_health_event.dart';
part 'get_health_state.dart';

class GetHealthBloc extends Bloc<GetHealthEvent, GetHealthState> {
  final HealthRepository _healthRepository;

  GetHealthBloc(this._healthRepository) : super(GetHealthInitial()) {
    on<GetHealth>((event, emit) async {
      emit(GetHealthLoading());
      try {
        if (event.healthId.isEmpty) {
          emit(
            GetHealthSuccess(
              health: Health.empty(),
              type: GetHealthType.getHealth,
              errorMessage: null,
            ),
          );
        } else {
          final health = await _healthRepository.getHealth(event.healthId);
          emit(
            GetHealthSuccess(
              health: health,
              type: GetHealthType.getHealth,
              errorMessage: null,
            ),
          );
        }
      } catch (e) {
        emit(
          GetHealthFailure(
            type: GetHealthType.getHealth,
            message: e.toString(),
          ),
        );
      }
    });

    on<SetHealth>((event, emit) async {
      emit(GetHealthLoading());
      try {
        await _healthRepository.setHealth(event.health, imageSrc: event.image);
        final health = await _healthRepository.getHealth(event.health.id);
        emit(
          GetHealthSuccess(
            health: health,
            type: GetHealthType.changeHealth,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(
          GetHealthSuccess(
            type: GetHealthType.changeHealth,
            errorMessage: e.toString(),
            health: event.health,
          ),
        );
      }
    });

    on<AddHealth>((event, emit) async {
      emit(GetHealthLoading());
      try {
        final p = await _healthRepository.addHealth(
          event.health,
          imageSrc: event.image,
        );
        emit(
          GetHealthSuccess(
            health: p,
            type: GetHealthType.addHealth,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(
          GetHealthSuccess(
            type: GetHealthType.addHealth,
            errorMessage: e.toString(),
            health: event.health,
          ),
        );
      }
    });

    on<RemoveHealth>((event, emit) async {
      emit(GetHealthLoading());
      try {
        await _healthRepository.removeHealth(event.healthId);
        emit(
          GetHealthSuccess(
            health: Health.empty(),
            type: GetHealthType.removeHealth,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(
          GetHealthFailure(
            type: GetHealthType.removeHealth,
            message: e.toString(),
          ),
        );
      }
    });
  }
}