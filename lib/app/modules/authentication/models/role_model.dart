import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Role {
  final String name;
  final String description;
  String? id;

  Role({required this.name, this.id, required this.description});

  Role copyWith({String? name, String? id, String? description}) => Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description);

  factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Role.fromJson(Map<String, dynamic> json) =>
      Role(name: json["name"], description: json["description"]);

  Map<String, dynamic> toJson() => {"name": name, "description": description};

  factory Role.fromSnapShot(DocumentSnapshot snap) {
    return Role(
        id: snap.id, name: snap["name"], description: snap["description"]);
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(name: map["name"], description: map["description"]);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "description": description};
  }
}
