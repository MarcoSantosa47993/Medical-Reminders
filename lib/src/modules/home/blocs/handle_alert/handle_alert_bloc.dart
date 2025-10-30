import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planning_repository/planning_repository.dart';

part 'handle_alert_event.dart';
part 'handle_alert_state.dart';

class HandleAlertBloc extends Bloc<HandleAlertEvent, HandleAlertState> {
  final PlanningRepository _planningRepository;

  HandleAlertBloc(this._planningRepository) : super(HandleAlertInitial()) {
    on<HandleTakeMedicine>((event, emit) async {
      try {
        emit(HandleAlertLoading());
        event.plan.taked = PlanningStatus.taked;
        await _planningRepository.setPlan(event.plan);
        emit(HandleAlertSuccess());
      } catch (e) {
        emit(HandleAlertFailure());
      }
    });

    on<HandleNotTakeMedicine>((event, emit) async {
      try {
        emit(HandleAlertLoading());
        event.plan.taked = PlanningStatus.notTaked;
        await _planningRepository.setPlan(event.plan);
        emit(HandleAlertSuccess());
      } catch (e) {
        emit(HandleAlertFailure());
      }
    });
  }
}