import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'device_model.dart';
import 'role_model.dart';

class User {
  final String buildNumber;
  final String createdAt;
  final String email;
  final String lastLogin;
  final String name;
  List<Role>? roles;

  List<Device>? devices;

  final String? uid;
  String? photoURL;
  String? password;

  User(
      {required this.buildNumber,
      required this.createdAt,
      required this.email,
      required this.lastLogin,
      required this.name,
      this.roles,
      this.uid,
      this.photoURL,
      this.password,
      this.devices});

  User copyWith(
          {String? buildNumber,
          String? createdAt,
          String? email,
          String? lastLogin,
          String? name,
          String? uid,
          String? photoURL}) =>
      User(
          buildNumber: buildNumber ?? this.buildNumber,
          createdAt: createdAt ?? this.createdAt,
          email: email ?? this.email,
          lastLogin: lastLogin ?? this.lastLogin,
          name: name ?? this.name,
          uid: uid ?? this.uid,
          photoURL: photoURL ?? this.photoURL);

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
      buildNumber: json["buildNumber"],
      createdAt: json["createdAt"],
      email: json["email"],
      lastLogin: json["lastSignInTime"],
      name: json["displayName"],
      uid: json["uid"],
      photoURL: json["photoURL"]);

  Map<String, dynamic> toJson() => {
        "buildNumber": buildNumber,
        "createdAt": createdAt,
        "email": email,
        "lastSignInTime": lastLogin,
        "displayName": name,
        "uid": uid,
        "photoURL": photoURL
      };

  factory User.fromSnapShot(DocumentSnapshot snap) {
    return User(
        buildNumber: snap["buildNumber"],
        createdAt: snap["createdAt"],
        email: snap["email"],
        lastLogin: snap["lastSignInTime"],
        name: snap["displayName"],
        uid: snap.id,
        photoURL: snap["photoURL"],
        password: snap["password"]);
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        buildNumber: map["buildNumber"],
        createdAt: map["createdAt"],
        email: map["email"],
        lastLogin: map["lastSignInTime"],
        name: map["displayName"],
        password: map["password"],
        uid: map["uid"],
        photoURL: map["photoURL"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "buildNumber": buildNumber,
      "createdAt": createdAt,
      "email": email,
      "lastSignInTime": lastLogin,
      "displayName": name,
      "photoURL": photoURL,
      "password": password,
      "uid": uid
    };
  }
}
