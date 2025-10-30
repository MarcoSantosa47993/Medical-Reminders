import 'package:equatable/equatable.dart';
import 'package:receipts_repository/receipts_repository.dart';

abstract class GetReceiptsState extends Equatable {
  const GetReceiptsState();
  @override
  List<Object?> get props => [];
}

class GetReceiptsInitial extends GetReceiptsState {}

class GetReceiptsLoading extends GetReceiptsState {}

class GetReceiptsSuccess extends GetReceiptsState {
  final List<Receipt> receipts;
  const GetReceiptsSuccess(this.receipts);

  @override
  List<Object?> get props => [receipts];
}

class GetReceiptsFailure extends GetReceiptsState {
  final String error;
  const GetReceiptsFailure(this.error);

  @override
  List<Object?> get props => [error];
}
