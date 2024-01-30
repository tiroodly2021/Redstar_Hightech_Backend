import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_type_model.dart';

class Transaction extends Equatable {
  final String? title;
  final String? description;
  Account account;
  //String account;
  TransactionType type;
  DateTime date;
  final double amount;

  String? id;

  Transaction(
      {this.id,
      this.description,
      this.title,
      required this.date,
      required this.account,
      required this.amount,
      required this.type});

  Transaction copyWith(
          {String? id,
          String? title,
          String? description,
          Account? account,
          TransactionType? type,
          DateTime? date,
          double? amount}) =>
      Transaction(
          title: title ?? this.title,
          description: description ?? this.description,
          date: date ?? this.date,
          id: id ?? this.id,
          account: account ?? this.account,
          amount: amount ?? this.amount,
          type: type ?? this.type);

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      title: json["title"],
      description: json["description"],
      date: json["date"],
      id: json["id"],
      type: json['type'],
      account: json['account'],
      amount: json["amount"]);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "date": date,
        "type": type,
        "amount": amount
      };

  factory Transaction.fromSnapShot(DocumentSnapshot snap) {
    return Transaction(
        title: snap["title"],
        description: snap["description"],
        date: snap['date'].toDate(),
        id: snap.id,
        type: Transaction.transactionIndexToTransactionType(snap['type']),
        amount: snap["amount"].toDouble(),
        account: Account.fromMap(snap['account']));
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        title: map["title"],
        description: map["description"],
        date: map["date"],
        id: map["id"],
        amount: map["amount"],
        type: map['type'],
        account: map['account']);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "account": account,
      "date": date,
      "type": transactionTypeToInt(type),
      "amount": amount,
      "account": account.toMap()..addAll({'id': account.id})
    };
  }

  static TransactionType transactionIndexToTransactionType(int index) {
    TransactionType transactionType = TransactionType.income;

    if (index == 0) {
      transactionType = TransactionType.income;
    }

    if (index == 1) {
      transactionType = TransactionType.expense;
    }

    /*  if (index == 2) {
      transactionType = TransactionType.transfert;
    } */

    return transactionType;
  }

  @override
  List<Object?> get props =>
      [title, description, account, type, date, amount, id];

  static TransactionType transactionStringToTransactionType(String str) {
    TransactionType transactionType = TransactionType.income;

    if (str == "Credit") {
      transactionType = TransactionType.income;
    }

    if (str == "Debit") {
      transactionType = TransactionType.expense;
    }

    /*  if (index == 2) {
      transactionType = TransactionType.transfert;
    } */

    return transactionType;
  }
}
/* 
List<Transaction> transactionsData = [
  Transaction(
      title: 'Fund wallet',
      description: 'to Jackson Botox',
      amount: 10560.00,
      type: TransactionType.income,
      account: '3434 4523 544',
      date: DateTime.now()),
  Transaction(
      title: 'Transfer',
      description: 'to James Brown',
      amount: 289.00,
      account: '3434 4523 544',
      type: TransactionType.transfert,
      date: DateTime.now()),
  Transaction(
      title: 'Transfer',
      description: 'to Jacob Jons',
      amount: 289.00,
      account: '3434 4523 544',
      type: TransactionType.expense,
      date: DateTime.now()),
  Transaction(
      title: 'Transfer',
      description: 'to James David',
      amount: 740.00,
      account: '3434 4523 544',
      type: TransactionType.transfert,
      date: DateTime.now()),
  Transaction(
      title: 'Fund wallet',
      description: 'to Jackson Botox',
      amount: 650.00,
      account: '3434 4523 544',
      type: TransactionType.transfert,
      date: DateTime.now()),
  Transaction(
      title: 'Transfer',
      description: 'to James Brown',
      amount: 500.00,
      account: '3434 4523 544',
      type: TransactionType.income,
      date: DateTime.now()),
  Transaction(
      title: 'Transfer',
      description: 'to Jacob Jons',
      amount: 2700.00,
      account: '3434 4523 544',
      type: TransactionType.transfert,
      date: DateTime.now()),
  Transaction(
      title: 'Transfer',
      description: 'to James David',
      amount: 200.00,
      account: '3434 4523 544',
      type: TransactionType.expense,
      date: DateTime.now()),
];
 */