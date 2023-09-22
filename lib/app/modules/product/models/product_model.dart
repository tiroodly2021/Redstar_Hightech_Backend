import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  String? id;
  String name;
  String description;
  double price;
  int quantity;
  String category;
  String imageUrl;
  bool isRecommended;
  bool isPopular;

  Product(
      {this.id,
      required this.name,
      required this.description,
      this.price = 0,
      this.quantity = 0,
      required this.category,
      required this.imageUrl,
      required this.isRecommended,
      required this.isPopular});

  Product copyWith(
      {String? id,
      String? name,
      String? description,
      int? price,
      int? quantity,
      String? category,
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
      'category': category,
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
        category: map['category'],
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
        category: snap['category'],
        imageUrl: snap['imageUrl'],
        quantity: snap['quantity'],
        price: snap['price'],
        isRecommended: snap['isRecommended'],
        isPopular: snap['isPopular']);
  }

  @override
  get stringify => true;

  static final List<Product> products = [
    Product(
        id: '1',
        name: "Soft Drink #1",
        description:
            "lorem ads asdasdsad asdasdasd sd asd asd asdd asda sdasd ",
        category: "Soft Drink #1",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        quantity: 4,
        isRecommended: true,
        isPopular: false),
    Product(
        id: '2',
        name: "Second Product",
        description: "adasd assdsadsad ssddsfdsfsdf",
        category: "Second Category",
        imageUrl:
            'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
        quantity: 5,
        price: 45,
        isRecommended: true,
        isPopular: false),
    Product(
        id: '3',
        description: "Third description of the national product",
        name: "Third Product",
        category: "Third Category",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        quantity: 6,
        price: 76,
        isRecommended: false,
        isPopular: true),
    Product(
        id: '4',
        description: "4 Description",
        name: "AXXXXX AXXX",
        category: "Second Category",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        quantity: 4,
        price: 12,
        isRecommended: false,
        isPopular: false),
    Product(
        id: '5',
        description: "5 Description of the product",
        name: "Fourth Product",
        category: "Second Category",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        price: 32,
        quantity: 4,
        isRecommended: false,
        isPopular: false),
    Product(
        id: '6',
        description: "Six description",
        name: "ewrwerewrv sdfsdf",
        category: "Third Category",
        imageUrl:
            'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
        price: 45,
        quantity: 4,
        isRecommended: true,
        isPopular: false),
    Product(
        id: '7',
        description: "7",
        name: "Third Product",
        category: "Third Category",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        price: 76,
        quantity: 4,
        isRecommended: true,
        isPopular: true),
    Product(
        id: '8',
        description: "8",
        name: "Third Product",
        category: "Third Category",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        price: 76,
        quantity: 4,
        isRecommended: false,
        isPopular: true),
    Product(
        id: '9',
        description: "9",
        name: "asd sdfdsf",
        category: "sdfdf Category",
        imageUrl:
            'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
        price: 32,
        quantity: 4,
        isRecommended: true,
        isPopular: false),
  ];
}
