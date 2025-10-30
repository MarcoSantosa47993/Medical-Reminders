part of 'add_receipt_bloc.dart';

abstract class AddReceiptState extends Equatable {
  const AddReceiptState();
  @override
  List<Object?> get props => [];
}

class AddReceiptInitial extends AddReceiptState {}

class AddReceiptLoading extends AddReceiptState {}

class AddReceiptSuccess extends AddReceiptState {}

class AddReceiptFailure extends AddReceiptState {
  final String error;
  const AddReceiptFailure(this.error);
  @override
  List<Object?> get props => [error];
}
