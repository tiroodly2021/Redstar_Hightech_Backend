enum TransactionType { income, expense, transfert }

String transactionTypeToString(TransactionType transactionType) {
  String output = '';
  if (transactionType == TransactionType.income) {
    output = "Credit";
  }

  if (transactionType == TransactionType.expense) {
    output = "Debit";
  }

  if (transactionType == TransactionType.transfert) {
    output = "Transfert";
  }

  return output;
}

int transactionTypeToInt(TransactionType transactionType) {
  int output = 0;
  if (transactionType == TransactionType.income) {
    output = 0;
  }

  if (transactionType == TransactionType.expense) {
    output = 1;
  }

  if (transactionType == TransactionType.transfert) {
    output = 2;
  }

  return output;
}
