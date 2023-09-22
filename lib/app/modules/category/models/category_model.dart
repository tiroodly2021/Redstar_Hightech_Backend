import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String? id;
  final String name;
  final String imageUrl;
  // final List<String>? colors;

  Category({this.id, required this.name, required this.imageUrl});

  Category copyWith(
      {final String? id, final String? name, final String? imageUrl}) {
    return Category(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'imageUrl': imageUrl};
  }

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
        id: map['id'], name: map['name'], imageUrl: map['imageUrl']);
  }

  factory Category.fromSnapShot(DocumentSnapshot snap) {
    return Category(
        id: snap.id, name: snap['name'], imageUrl: snap['imageUrl']);
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [id, name, imageUrl];

  /* static List<Category> orders = [
    Category(
        id: "dsdnD",
        name: "Water",
        imageUrl:
            "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
    Category(
        id: "dsdnD",
        name: "Smoothies",
        imageUrl:
            "https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80"),
    Category(
        id: "dsdnD",
        name: "Soft drinks",
        imageUrl:
            "https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80"),
  ]; */
}
