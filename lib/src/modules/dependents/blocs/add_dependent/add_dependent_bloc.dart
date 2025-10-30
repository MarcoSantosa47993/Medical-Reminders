import 'package:bloc/bloc.dart';
import 'package:dependents_repository/dependents_repository.dart';
import 'package:equatable/equatable.dart';

part 'add_dependent_event.dart';
part 'add_dependent_state.dart';

class AddDependentBloc extends Bloc<AddDependentEvent, AddDependentState> {
  final DependentsRepository _dependentsRepository;

  AddDependentBloc(this._dependentsRepository) : super(AddDependentInitial()) {
    on<AddDependent>((event, emit) async {
      try {
        emit(AddDependentLoading());

        await _dependentsRepository.addDependent(event.pinCode);

        emit(AddDependentSuccess());
      } catch (e) {
        emit(AddDependentFailure());
      }
    });
  }
}
