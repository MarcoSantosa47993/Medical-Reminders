import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:planning_repository/planning_repository.dart';

part 'get_plan_event.dart';
part 'get_plan_state.dart';

class GetPlanBloc extends Bloc<GetPlanEvent, GetPlanState> {
  final PlanningRepository _planningRepository;

  GetPlanBloc(this._planningRepository) : super(GetPlanInitial()) {
    on<GetPlan>((event, emit) async {
      emit(GetPlanLoading());
      try {
        if (event.planId.isEmpty) {
          emit(
            GetPlanSuccess(
              plan: Planning.empty(),
              type: GetPlanType.getPlan,
              errorMessage: null,
            ),
          );
        } else {
          final plan = await _planningRepository.getPlan(event.planId);
          emit(
            GetPlanSuccess(
              plan: plan,
              type: GetPlanType.getPlan,
              errorMessage: null,
            ),
          );
        }
      } catch (e) {
        emit(GetPlanFailure(type: GetPlanType.getPlan, message: e.toString()));
      }
    });

    on<NewPlan>((event, emit) async {
      emit(GetPlanLoading());
      try {
        final p = await _planningRepository.addPlan(event.plan);
        emit(
          GetPlanSuccess(
            plan: p,
            type: GetPlanType.addPlan,
            errorMessage: null,
          ),
        );
      } catch (e) {
        //emit(GetPlanFailure(type: GetPlanType.getPlan, message: e.toString()));
        emit(
          GetPlanSuccess(
            plan: event.plan,
            type: GetPlanType.addPlan,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<RemovePlan>((event, emit) async {
      emit(GetPlanLoading());
      try {
        await _planningRepository.removePlan(event.planId, event.medicineId);
        emit(
          GetPlanSuccess(
            plan: Planning.empty(),
            type: GetPlanType.removePlan,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(GetPlanFailure(type: GetPlanType.getPlan, message: e.toString()));
      }
    });

    on<SetPlan>((event, emit) async {
      emit(GetPlanLoading());
      try {
        await _planningRepository.setPlan(event.plan);
        emit(
          GetPlanSuccess(
            plan: Planning.empty(),
            type: GetPlanType.addPlan,
            errorMessage: null,
          ),
        );
      } catch (e) {
        //emit(GetPlanFailure(type: GetPlanType.getPlan, message: e.toString()));
        emit(
          GetPlanSuccess(
            plan: event.plan,
            type: GetPlanType.addPlan,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
