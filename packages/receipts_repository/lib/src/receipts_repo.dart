import 'package:receipts_repository/receipts_repository.dart';

abstract class ReceiptsRepository {
  Future<List<Receipt>> getMyReceipts();

  Future<void> adjustMedicinStock(List<MedicinPurchaseInput> purchases);

  Future<void> addReceipt(
    String receiptNumber,
    DateTime emittedDate,
    DateTime expireDate,
    List<MedicinPurchaseInput> purchases,
  );

  Future<void> setReceipt(Receipt receipt);

  Future<void> removeReceipt(String receiptId);
}
