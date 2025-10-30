import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'update_create_plan_event.dart';
part 'update_create_plan_state.dart';

class UpdateCreatePlanBloc extends Bloc<UpdateCreatePlanEvent, UpdateCreatePlanState> {
  UpdateCreatePlanBloc() : super(UpdateCreatePlanInitial()) {
    on<UpdateCreatePlanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
