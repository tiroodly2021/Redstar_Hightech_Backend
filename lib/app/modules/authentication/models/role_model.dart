import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'permission_model.dart';

class Role {
  final String name;
  final String description;
  String? id;
  List<String>? permissionIds;

  Role(
      {required this.name,
      this.id,
      required this.description,
      this.permissionIds});

  Role copyWith(
          {String? name,
          String? id,
          String? description,
          List<String>? permissionIds}) =>
      Role(
          id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description,
          permissionIds: permissionIds ?? this.permissionIds);

  factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Role.fromJson(Map<String, dynamic> json) =>
      Role(name: json["name"], description: json["description"]);

  Map<String, dynamic> toJson() => {"name": name, "description": description};

  factory Role.fromSnapShot(DocumentSnapshot snap) {
    print(snap["permissionIds"]);
    return Role(
        id: snap.id,
        name: snap["name"],
        description: snap["description"],
        permissionIds: List<String>.from(snap['permissionIds']
            as List) /* snap["permissions"] as List<Permission>? */

        );
  }

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      name: map["name"],
      description: map["description"],
      permissionIds: map["permissionIds"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "permissionIds": permissionIds
    };
  }
}
