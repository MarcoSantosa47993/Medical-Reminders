import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planning_repository/planning_repository.dart';

part 'get_plans_event.dart';
part 'get_plans_state.dart';

class GetPlansBloc extends Bloc<GetPlansEvent, GetPlansState> {
  final PlanningRepository _planningRepository;

  GetPlansBloc(this._planningRepository) : super(GetPlansInitial()) {
    on<GetPlans>((event, emit) async {
      try {
        emit(GetPlansLoading());
        final plans = await _planningRepository.getPlans(event.date);
        emit(GetPlansSuccess(plans: plans));
      } catch (e) {
        emit(GetPlansFailure());
      }
    });
  }
}
