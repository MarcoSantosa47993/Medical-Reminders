import 'package:bloc/bloc.dart';
import 'package:dependents_repository/dependents_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_dependents_event.dart';
part 'get_dependents_state.dart';

class GetDependentsBloc extends Bloc<GetDependentsEvent, GetDependentsState> {
  final DependentsRepository _dependentsRepository;

  GetDependentsBloc(this._dependentsRepository)
    : super(GetDependentsInitial()) {
    on<GetDependents>((event, emit) async {
      emit(GetDependentsLoading());
      try {
        final dependents = await _dependentsRepository.getMyDependents();
        emit(GetDependentsSuccess(dependents: dependents));
      } catch (e) {
        emit(GetDependentsFailure());
      }
    });
  }
}
