import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planning_repository/planning_repository.dart';

part 'get_alerts_event.dart';
part 'get_alerts_state.dart';

class GetAlertsBloc extends Bloc<GetAlertsEvent, GetAlertsState> {
  final PlanningRepository _planningRepository;

  GetAlertsBloc(this._planningRepository) : super(GetAlertsInitial()) {
    on<GetAlerts>((event, emit) async {
      try {
        emit(GetAlertsLoading());
        final alerts = await _planningRepository.getAlerts();
        emit(GetAlertsSuccess(alerts));
      } catch (e) {
        emit(GetAlertsFailure());
      }
    });
  }
}