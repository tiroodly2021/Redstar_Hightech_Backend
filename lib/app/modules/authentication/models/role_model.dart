import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String name;
  String? id;

  Role({required this.name, this.id});

  Role copyWith({String? name, String? id}) =>
      Role(id: id ?? this.id, name: name ?? this.name);

  factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Role.fromJson(Map<String, dynamic> json) => Role(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};

  factory Role.fromSnapShot(DocumentSnapshot snap) {
    return Role(
      id: snap.id,
      name: snap["name"],
    );
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      name: map["name"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
    };
  }
}
