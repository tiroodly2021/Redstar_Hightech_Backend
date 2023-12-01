import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String buildNumber;
  final String createdAt;
  final String email;
  final String lastLogin;
  final String name;
  final String role;
  final String uid;

  User(
      {required this.buildNumber,
      required this.createdAt,
      required this.email,
      required this.lastLogin,
      required this.name,
      required this.role,
      required this.uid});

  User copyWith(
          {String? buildNumber,
          String? createdAt,
          String? email,
          String? lastLogin,
          String? name,
          String? role,
          String? ui}) =>
      User(
          buildNumber: buildNumber ?? this.buildNumber,
          createdAt: createdAt ?? this.createdAt,
          email: email ?? this.email,
          lastLogin: lastLogin ?? this.lastLogin,
          name: name ?? this.name,
          role: role ?? this.role,
          uid: ui ?? this.uid);

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        buildNumber: json["buildNumber"],
        createdAt: json["createdAt"],
        email: json["email"],
        lastLogin: json["lastSignInTime"],
        name: json["displayName"],
        role: json["role"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "buildNumber": buildNumber,
        "createdAt": createdAt,
        "email": email,
        "lastSignInTime": lastLogin,
        "displayName": name,
        "role": role,
        "uid": uid
      };

  factory User.fromSnapShot(DocumentSnapshot snap) {
    return User(
        buildNumber: snap["buildNumber"],
        createdAt: snap["createdAt"],
        email: snap["email"],
        lastLogin: snap["lastSignInTime"],
        name: snap["displayName"],
        role: snap["role"],
        uid: snap.id);
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        buildNumber: map["buildNumber"],
        createdAt: map["createdAt"],
        email: map["email"],
        lastLogin: map["lastSignInTime"],
        name: map["displayName"],
        role: map["role"],
        uid: map["uid"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "buildNumber": buildNumber,
      "createdAt": createdAt,
      "email": email,
      "lastSignInTime": lastLogin,
      "displayName": name,
      "role": role,
      "uid": uid
    };
  }
}
