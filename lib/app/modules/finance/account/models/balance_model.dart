import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';

class Balances {
  final String name;
  Account account;
  final String balance;
  final String expiryDate;
  final String id;

  Balances({
    required this.name,
    required this.account,
    required this.balance,
    required this.expiryDate,
    required this.id,
  });

  factory Balances.fromJson(Map<String, dynamic> json) => Balances(
        name: json["name"],
        account: json["number"],
        balance: json["balance"],
        expiryDate: json["expiry_Date"],
        id: json["id"],
      );

  factory Balances.fromSnapShot(DocumentSnapshot snap) {
    return Balances(
        name: snap["name"],
        account: Account.fromSnapShot(snap["number"]),
        balance: snap["balance"],
        id: snap.id,
        expiryDate: snap["expiryDate"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "account": account.toMap()..addAll({'id': account.id}),
      "balance": balance,
      "expiry_Date": expiryDate,
      "id": id,
    };
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "account": account,
        "balance": balance,
        "expiry_Date": expiryDate,
        "id": id,
      };
}
