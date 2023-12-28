import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:redstar_hightech_backend/app/modules/category/models/category_model.dart';

class Product extends Equatable {
  String? id;
  String name;
  String description;
  double price;
  int quantity;
  //String category;
  List<Category>? category;
  String imageUrl;
  bool isRecommended;
  bool isPopular;

  Product(
      {this.id,
      required this.name,
      required this.description,
      this.price = 0,
      this.quantity = 0,
      this.category,
      required this.imageUrl,
      required this.isRecommended,
      required this.isPopular});

  Product copyWith(
      {String? id,
      String? name,
      String? description,
      int? price,
      int? quantity,
      List<Category>? category,
      String? imageUrl,
      bool? isRecommended,
      bool? isPopular}) {
    return Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        price: price!.toDouble(),
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl ?? this.imageUrl,
        isRecommended: isRecommended ?? this.isRecommended,
        isPopular: isPopular ?? this.isPopular);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        quantity,
        category,
        imageUrl,
        isRecommended,
        isPopular
      ];

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      // 'category': category,
      'description': description,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'isRecommended': isRecommended,
      'isPopular': isPopular
    };
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        // id: map['id'],
        name: map['name'],
        description: map['description'],
        // category: map['category'],
        imageUrl: map['imageUrl'],
        price: map['price'],
        quantity: map['quantity'],
        isRecommended: map['isRecommended'],
        isPopular: map['isPopular']);
  }

  factory Product.fromSnapShot(DocumentSnapshot snap) {
    return Product(
        id: snap.id,
        name: snap['name'],
        description: snap['description'],
        //category: snap['category'],
        imageUrl: snap['imageUrl'],
        quantity: snap['quantity'],
        price: snap['price'],
        isRecommended: snap['isRecommended'],
        isPopular: snap['isPopular']);
  }

  @override
  get stringify => true;
}
