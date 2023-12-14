import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'role_model.dart';

class Device {
  final String createdAt;
  final String updatedAt;
  final bool uninstalled;
  Map<String, dynamic>? deviceInfo;
  String? id;

  Device({
    required this.createdAt,
    required this.updatedAt,
    required this.uninstalled,
    this.deviceInfo,
    this.id,
  });

  Device copyWith(
          {String? createdAt,
          String? updatedAt,
          bool? uninstalled,
          Map<String, dynamic>? deviceInfo,
          String? id}) =>
      Device(
          createdAt: createdAt ?? this.createdAt,
          uninstalled: uninstalled ?? this.uninstalled,
          updatedAt: updatedAt ?? this.updatedAt,
          deviceInfo: deviceInfo ?? this.deviceInfo,
          id: id ?? this.id);

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
      createdAt: json["createdAt"],
      uninstalled: json["uninstalled"],
      updatedAt: json["updatedAt"],
      deviceInfo: json["deviceInfo"],
      id: json["id"]);

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "uninstalled": uninstalled,
        "updatedAt": updatedAt,
        "deviceInfo": deviceInfo,
      };

  factory Device.fromSnapShot(DocumentSnapshot snap) {
    return Device(
        createdAt: snap["createdAt"],
        uninstalled: snap["uninstalled"],
        updatedAt: snap["updatedAt"],
        deviceInfo: snap["deviceInfo"],
        id: snap.id);
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
        createdAt: map["createdAt"],
        uninstalled: map["uninstalled"],
        updatedAt: map["updatedAt"],
        deviceInfo: map["deviceInfo"],
        id: map["id"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "uninstalled": uninstalled,
      "updatedAt": updatedAt,
      "deviceInfo": deviceInfo,
    };
  }
}
