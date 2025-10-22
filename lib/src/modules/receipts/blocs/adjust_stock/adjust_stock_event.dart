part of 'adjust_stock_bloc.dart';

abstract class AdjustStockEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdjustStockRequested extends AdjustStockEvent {
  final List<MedicinPurchaseInput> purchases;

  AdjustStockRequested(this.purchases);

  @override
  List<Object?> get props => [purchases];
}
