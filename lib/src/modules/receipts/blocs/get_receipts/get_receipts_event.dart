import 'package:equatable/equatable.dart';

abstract class GetReceiptsEvent extends Equatable {
  const GetReceiptsEvent();
  @override
  List<Object?> get props => [];
}

class LoadReceipts extends GetReceiptsEvent {
  const LoadReceipts();
  @override
  List<Object?> get props => [];
}
