part of 'adjust_stock_bloc.dart';

abstract class AdjustStockState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdjustStockInitial extends AdjustStockState {}

class AdjustStockLoading extends AdjustStockState {}

class AdjustStockSuccess extends AdjustStockState {}

class AdjustStockFailure extends AdjustStockState {
  final String error;
  AdjustStockFailure(this.error);
  @override
  List<Object?> get props => [error];
}
