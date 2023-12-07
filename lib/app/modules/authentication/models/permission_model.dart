import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../authentication/models/role_model.dart';
import 'model_action.dart';

class Permission extends Equatable {
  String description;
  String? id;
  bool? read;
  bool? write;
  bool? delete;
  String role;

  Permission(
      {required this.description,
      this.id,
      this.read = false,
      this.write = false,
      this.delete = false,
      required this.role});

  Permission copyWith(
          {String? id,
          String? description,
          bool? read,
          bool? write,
          bool? delete,
          String? role}) =>
      Permission(
          description: description ?? this.description,
          id: id ?? this.id,
          read: read ?? this.read,
          write: write ?? this.write,
          delete: delete ?? this.delete,
          role: role ?? this.role);

  factory Permission.fromRawJson(String str) =>
      Permission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        description: json["description"],
        read: json["read"],
        write: json["write"],
        delete: json["delete"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "role": role,
        "read": read,
        "write": write,
        "delete": delete
      };

  factory Permission.fromSnapShot(DocumentSnapshot snap) {
    return Permission(
      id: snap.id,
      description: snap["description"],
      read: snap["read"],
      write: snap["write"],
      delete: snap["delete"],
      role: snap["role"],
    );
  }

  factory Permission.fromMap(Map<String, dynamic> map) {
    return Permission(
      description: map["description"],
      read: map["read"],
      write: map["write"],
      delete: map["delete"],
      role: map["role"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "role": role,
      "read": read,
      "write": write,
      "delete": delete
    };
  }

  @override
  List<Object?> get props => [read, write, delete];
}
