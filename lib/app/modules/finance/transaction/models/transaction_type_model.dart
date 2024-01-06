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
