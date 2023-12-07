import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Action {
  final String name;
  final String description;
  String? id;

  Action({required this.name, this.id, required this.description});

  Action copyWith({String? name, String? id, String? description}) => Action(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description);

  factory Action.fromRawJson(String str) => Action.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Action.fromJson(Map<String, dynamic> json) =>
      Action(name: json["name"], description: json["description"]);

  Map<String, dynamic> toJson() => {"name": name, "description": description};

  factory Action.fromSnapShot(DocumentSnapshot snap) {
    return Action(
        id: snap.id, name: snap["name"], description: snap["description"]);
  }

  factory Action.fromMap(Map<String, dynamic> map) {
    return Action(name: map["name"], description: map["description"]);
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "description": description};
  }
}
