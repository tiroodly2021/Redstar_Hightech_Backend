enum AccountType { mobileAgent, lotoAgent, cashMoney }

int accountTypeToInt(AccountType accountType) {
  int output = 0;
  if (accountType == AccountType.mobileAgent) {
    output = 0;
  }

  if (accountType == AccountType.lotoAgent) {
    output = 1;
  }

  if (accountType == AccountType.cashMoney) {
    output = 2;
  }

  return output;
}

String accountTypeToString(AccountType accountType) {
  String out = '';

  if (accountType == AccountType.mobileAgent) {
    out = "Mobile Agent";
  }
  if (accountType == AccountType.lotoAgent) {
    out = "Loto Agent";
  }
  if (accountType == AccountType.cashMoney) {
    out = "Cash";
  }

  return out;
}
