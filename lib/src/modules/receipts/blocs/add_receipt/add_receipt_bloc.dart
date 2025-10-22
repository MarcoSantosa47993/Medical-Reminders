import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:receipts_repository/receipts_repository.dart';

part 'add_receipt_event.dart';
part 'add_receipt_state.dart';

class AddReceiptBloc extends Bloc<AddOrUpdateReceipt, AddReceiptState> {
  final ReceiptsRepository repository;

  AddReceiptBloc({required this.repository}) : super(AddReceiptInitial()) {
    on<AddOrUpdateReceipt>(_onAddOrUpdate);
  }

  Future<void> _onAddOrUpdate(
    AddOrUpdateReceipt event,
    Emitter<AddReceiptState> emit,
  ) async {
    print(
      '[AddReceiptBloc] recebendo evento para receiptId=${event.receiptId}',
    );
    emit(AddReceiptLoading());
    try {
      final receipt = Receipt(
        id: event.receiptId,
        receiptNumber: event.receiptNumber,
        emittedDate: event.emittedDate,
        expireDate: event.expireDate,
        medications: event.medications,
      );
      await repository.setReceipt(receipt);
      emit(AddReceiptSuccess());
    } catch (e) {
      emit(AddReceiptFailure(e.toString()));
    }
  }
}
