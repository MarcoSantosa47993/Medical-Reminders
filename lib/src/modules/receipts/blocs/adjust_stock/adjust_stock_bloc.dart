import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipts_repository/receipts_repository.dart';

part 'adjust_stock_event.dart';
part 'adjust_stock_state.dart';

class AdjustStockBloc extends Bloc<AdjustStockEvent, AdjustStockState> {
  final ReceiptsRepository _repo;

  AdjustStockBloc(this._repo) : super(AdjustStockInitial()) {
    on<AdjustStockRequested>(_onAdjust);
  }

  Future<void> _onAdjust(
    AdjustStockRequested event,
    Emitter<AdjustStockState> emit,
  ) async {
    emit(AdjustStockLoading());
    try {
      await _repo.adjustMedicinStock(event.purchases);
      emit(AdjustStockSuccess());
    } catch (e) {
      emit(AdjustStockFailure(e.toString()));
    }
  }
}
