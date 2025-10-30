import 'package:equatable/equatable.dart';

abstract class GetReceiptEvent extends Equatable {
  const GetReceiptEvent();
  @override
  List<Object?> get props => [];
}

class LoadReceipt extends GetReceiptEvent {
  final String receiptId;
  const LoadReceipt({required this.receiptId});
  @override
  List<Object?> get props => [receiptId];
}

class RemoveReceipt extends GetReceiptEvent {
  final String receiptId;
  const RemoveReceipt({required this.receiptId});
  @override
  List<Object?> get props => [receiptId];
}
