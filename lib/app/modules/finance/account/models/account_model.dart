import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_type.dart';

class Account extends Equatable {
  final String? id;
  final String number;
  final String createdAt;
  final String name;

  AccountType? type;
  String? photoURL;

  Account(
      {required this.number,
      required this.createdAt,
      required this.name,
      this.type,
      this.id,
      this.photoURL});

  Account copyWith(
          {String? number,
          String? createdAt,
          String? name,
          AccountType? type,
          String? uid,
          String? photoURL}) =>
      Account(
          number: number ?? this.number,
          createdAt: createdAt ?? this.createdAt,
          name: name ?? this.name,
          type: type ?? this.type,
          id: id ?? this.id,
          photoURL: photoURL ?? this.photoURL);

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
      number: json["number"],
      createdAt: json["createdAt"],
      name: json["name"],
      type: json['type'],
      id: json["id"],
      photoURL: json["photoURL"]);

  Map<String, dynamic> toJson() => {
        "number": number,
        "createdAt": createdAt,
        "name": name,
        "type": type,
        "photoURL": photoURL
      };

  factory Account.fromSnapShot(DocumentSnapshot snap) {
    return Account(
        number: snap["number"],
        createdAt: snap["createdAt"],
        name: snap["name"],
        type: Account.accountIndexToAccountType(snap['type']),
        id: snap.id,
        photoURL: snap["photoURL"]);
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        number: map["number"],
        createdAt: map["createdAt"],
        name: map["name"],
        type: Account.accountIndexToAccountType(map['type']),
        id: map["id"],
        photoURL: map["photoURL"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "number": number,
      "createdAt": createdAt,
      "name": name,
      "type": type != null ? accountTypeToInt(type!) : -1,
      "photoURL": photoURL
    };
  }

  static AccountType? accountIndexToAccountType(int index) {
    AccountType accountType = AccountType.mobileAgent;

    if (index == 0) {
      accountType = AccountType.mobileAgent;
    }

    if (index == 1) {
      accountType = AccountType.lotoAgent;
    }

    if (index == 2) {
      accountType = AccountType.cashMoney;
    }

    if (index == -1) {
      return null;
    }

    return accountType;
  }

  static AccountType? accountStringToAccountType(String str) {
    AccountType accountType = AccountType.mobileAgent;

    if (str == "Mobile Agent") {
      accountType = AccountType.mobileAgent;
    }

    if (str == "Loto Agent") {
      accountType = AccountType.lotoAgent;
    }

    if (str == "Cash") {
      accountType = AccountType.cashMoney;
    }

    if (str == "") {
      return null;
    }

    return accountType;
  }

  @override
  List<Object?> get props => [id, number, createdAt, name, photoURL];
}
