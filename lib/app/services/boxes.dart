import 'package:hive/hive.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactionsBox() =>
      Hive.box<Transaction>('transactions');
  static Box getStorageBox() => Hive.box('storage');
}
