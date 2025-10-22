import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts_repository/receipts_repository.dart';

import 'get_receipts_event.dart';
import 'get_receipts_state.dart';

class GetReceiptsBloc extends Bloc<GetReceiptsEvent, GetReceiptsState> {
  final ReceiptsRepository _repository;

  GetReceiptsBloc({required ReceiptsRepository repository})
    : _repository = repository,
      super(GetReceiptsInitial()) {
    on<LoadReceipts>(_onLoadReceipts);
  }

  Future<void> _onLoadReceipts(
    LoadReceipts event,
    Emitter<GetReceiptsState> emit,
  ) async {
    emit(GetReceiptsLoading());
    try {
      final receipts = await _repository.getMyReceipts();
      emit(GetReceiptsSuccess(receipts));
    } catch (e) {
      emit(GetReceiptsFailure(e.toString()));
    }
  }
}
