import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipts_repository/receipts_repository.dart';

import 'get_receipt_event.dart';
import 'get_receipt_state.dart';

class GetReceiptBloc extends Bloc<GetReceiptEvent, GetReceiptState> {
  final ReceiptsRepository _repository;

  GetReceiptBloc({required ReceiptsRepository repository})
    : _repository = repository,
      super(const GetReceiptInitial()) {
    on<LoadReceipt>(_onLoadReceipt);
    on<RemoveReceipt>(_onRemoveReceipt);
  }

  Future<void> _onLoadReceipt(
    LoadReceipt event,
    Emitter<GetReceiptState> emit,
  ) async {
    emit(const GetReceiptLoading(GetReceiptType.getReceipt));
    try {
      final all = await _repository.getMyReceipts();
      final match = all.firstWhere(
        (r) => r.id == event.receiptId,
        orElse: () => throw Exception("Recibo não encontrado"),
      );
      emit(GetReceiptSuccess(type: GetReceiptType.getReceipt, receipt: match));
    } catch (e) {
      emit(
        GetReceiptFailure(type: GetReceiptType.getReceipt, error: e.toString()),
      );
    }
  }

  Future<void> _onRemoveReceipt(
    RemoveReceipt event,
    Emitter<GetReceiptState> emit,
  ) async {
    emit(const GetReceiptLoading(GetReceiptType.removeReceipt));
    try {
      await _repository.removeReceipt(event.receiptId);
      emit(
        const GetReceiptSuccess(
          type: GetReceiptType.removeReceipt,
          receipt: null,
        ),
      );
    } catch (e) {
      emit(
        GetReceiptFailure(
          type: GetReceiptType.removeReceipt,
          error: e.toString(),
        ),
      );
    }
  }
}
