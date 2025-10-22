import 'package:equatable/equatable.dart';
import 'package:receipts_repository/receipts_repository.dart';

enum GetReceiptType { getReceipt, removeReceipt }

abstract class GetReceiptState extends Equatable {
  final GetReceiptType type;
  const GetReceiptState(this.type);
  @override
  List<Object?> get props => [type];
}

class GetReceiptInitial extends GetReceiptState {
  const GetReceiptInitial() : super(GetReceiptType.getReceipt);
}

class GetReceiptLoading extends GetReceiptState {
  const GetReceiptLoading(GetReceiptType type) : super(type);
}

class GetReceiptSuccess extends GetReceiptState {
  final Receipt? receipt;
  const GetReceiptSuccess({required GetReceiptType type, required this.receipt})
    : super(type);

  @override
  List<Object?> get props => [type, receipt ?? ""];
}

class GetReceiptFailure extends GetReceiptState {
  final String error;
  const GetReceiptFailure({required GetReceiptType type, required this.error})
    : super(type);

  @override
  List<Object?> get props => [type, error];
}
