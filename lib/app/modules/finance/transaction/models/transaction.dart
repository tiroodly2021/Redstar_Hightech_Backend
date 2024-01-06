/* import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart';

enum TransactionType {
  income,
  expense,
}

class Transaction extends Equatable {
  String? id;
  DateTime date;
  List<Account>? category;
  double amount;

  List<TransactionType> type;

  String? description;
  Transaction(
      {required this.date,
      required this.category,
      required this.amount,
      required this.type,
      this.id,
      this.description});

  Transaction copyWith(
          {DateTime? date,
          List<Account>? account,
          double? amount,
          String? id,
          List<TransactionType>? type,
          String? description}) =>
      Transaction(
          date: date ?? this.date,
          category: category ?? this.category,
          amount: amount ?? this.amount,
          id: id ?? this.id,
          type: type ?? this.type,
          description: description ?? this.description);

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
      date: json["date"],
      amount: json["amount"],
      category: json["account"],
      type: json['type']);

  Map<String, dynamic> toJson() =>
      {"date": date, "amount": amount, "account": category, "type": type};

  factory Transaction.fromSnapShot(DocumentSnapshot snap) {
    return Transaction(
        date: snap["date"],
        category: snap["account"],
        amount: snap["amount"],
        id: snap.id,
        type: snap["type"],
        description: snap['description']);
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
        date: map["date"],
        category: map["account"],
        amount: map["amount"],
        type: map["type"],
        description: map['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "account": category,
      "amount": amount,
      "type": type,
      "id": id,
      'description': description
    };
  }

  @override
  String toString() {
    return 'date: $date,category: $category,amount: $amount,type: $type, description: $description';
  }

  @override
  List<Object?> get props => [];
}
 */

import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  String category;
  @HiveField(3)
  double amount;
  @HiveField(4)
  TransactionType type;
  @HiveField(5)
  String? description;
  Transaction(
      {required this.date,
      required this.category,
      required this.amount,
      required this.type,
      this.description});
  @override
  String toString() {
    return 'date: $date,category: $category,amount: $amount,type: $type, description: $description';
  }
} 

/* 
 */