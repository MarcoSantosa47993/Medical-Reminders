part of 'add_receipt_bloc.dart';

class AddOrUpdateReceipt extends Equatable {
  final String receiptId;
  final String receiptNumber;
  final DateTime emittedDate;
  final DateTime expireDate;
  final List<MedicinPurchase> medications;

  const AddOrUpdateReceipt({
    required this.receiptId,
    required this.receiptNumber,
    required this.emittedDate,
    required this.expireDate,
    required this.medications,
  });

  @override
  List<Object?> get props => [
    receiptId,
    receiptNumber,
    emittedDate,
    expireDate,
    medications,
  ];
}
