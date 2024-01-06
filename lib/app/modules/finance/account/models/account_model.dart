import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account_category/models/account_category.dart';

class Account {
  final String? id;
  final String number;
  final String createdAt;
  final String name;
  List<AccountCategory>? categories;
  String? photoURL;
  double? balanceCredit = 0;
  double? balanceDebit = 0;

  Account(
      {required this.number,
      required this.createdAt,
      required this.name,
      this.categories,
      this.id,
      this.photoURL,
      this.balanceCredit,
      this.balanceDebit});

  Account copyWith(
          {String? number,
          String? createdAt,
          String? name,
          String? uid,
          String? photoURL,
          double? blanceCredit,
          double? balanceDebit}) =>
      Account(
          number: number ?? this.number,
          createdAt: createdAt ?? this.createdAt,
          name: name ?? this.name,
          id: id ?? this.id,
          photoURL: photoURL ?? this.photoURL,
          balanceCredit: balanceCredit ?? this.balanceCredit,
          balanceDebit: balanceDebit ?? this.balanceDebit);

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
      number: json["number"],
      createdAt: json["createdAt"],
      name: json["name"],
      id: json["id"],
      photoURL: json["photoURL"],
      balanceCredit: json['balanceCredit'],
      balanceDebit: json['balanceDebit']);

  Map<String, dynamic> toJson() => {
        "number": number,
        "createdAt": createdAt,
        "name": name,
        "id": id,
        "photoURL": photoURL,
        'balanceCredit': balanceCredit,
        'balanceDebit': balanceDebit
      };

  factory Account.fromSnapShot(DocumentSnapshot snap) {
    return Account(
        number: snap["number"],
        createdAt: snap["createdAt"],
        name: snap["name"],
        id: snap.id,
        photoURL: snap["photoURL"],
        balanceCredit: snap['balanceCredit'],
        balanceDebit: snap['balanceDebit']);
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        number: map["number"],
        createdAt: map["createdAt"],
        name: map["name"],
        id: map["id"],
        photoURL: map["photoURL"],
        balanceCredit: map['balanceCredit'],
        balanceDebit: map['balanceDebit']);
  }

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "createdAt": createdAt,
      "name": name,
      "photoURL": photoURL,
      "id": id,
      'balanceCredit': balanceCredit,
      'balanceDebit': balanceDebit
    };
  }
}
