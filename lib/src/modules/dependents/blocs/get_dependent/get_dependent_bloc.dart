import 'package:bloc/bloc.dart';
import 'package:dependents_repository/dependents_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_dependent_event.dart';
part 'get_dependent_state.dart';

class GetDependentBloc extends Bloc<GetDependentEvent, GetDependentState> {
  final DependentsRepository _dependentsRepository;

  GetDependentBloc(this._dependentsRepository) : super(GetDependentInitial()) {
    on<GetDependent>((event, emit) async {
      emit(GetDependentLoading());
      try {
        final dependent = await _dependentsRepository.getDependent(
          event.dependentId,
        );
        emit(
          GetDependentSuccess(
            dependent: dependent,
            type: GetDependentType.getDependent,
          ),
        );
      } catch (e) {
        emit(GetDependentFailure(type: GetDependentType.getDependent));
      }
    });

    on<SetDependent>((event, emit) async {
      emit(GetDependentLoading());
      try {
        await _dependentsRepository.setDependent(event.dependent);
        final dependent = await _dependentsRepository.getDependent(
          event.dependent.id,
        );
        emit(
          GetDependentSuccess(
            dependent: dependent,
            type: GetDependentType.changeDependent,
          ),
        );
      } catch (e) {
        emit(GetDependentFailure(type: GetDependentType.changeDependent));
      }
    });

    on<RemoveDependent>((event, emit) async {
      emit(GetDependentLoading());
      try {
        await _dependentsRepository.removeDependent(event.dependentId);
        emit(
          GetDependentSuccess(
            dependent: null,
            type: GetDependentType.removeDependent,
          ),
        );
      } catch (e) {
        emit(GetDependentFailure(type: GetDependentType.removeDependent));
      }
    });
  }
}
