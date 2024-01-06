import 'package:cloud_firestore/cloud_firestore.dart';

class Balances {
  final String name;
  final String number;
  final String balance;
  final String expiryDate;
  final String id;

  Balances({
    required this.name,
    required this.number,
    required this.balance,
    required this.expiryDate,
    required this.id,
  });

  factory Balances.fromJson(Map<String, dynamic> json) => Balances(
        name: json["name"],
        number: json["number"],
        balance: json["balance"],
        expiryDate: json["expiry_Date"],
        id: json["id"],
      );

  factory Balances.fromSnapShot(DocumentSnapshot snap) {
    return Balances(
        name: snap["name"],
        number: snap["number"],
        balance: snap["balance"],
        id: snap.id,
        expiryDate: snap["expiryDate"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "number": number,
      "balance": balance,
      "expiry_Date": expiryDate,
      "id": id,
    };
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "balance": balance,
        "expiry_Date": expiryDate,
        "id": id,
      };
}
