import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String? id;
  final int customerId;
  final List<String> productIds; //List<int> productIds;
  final double deliveryFee;
  final double subtotal;
  final double total;
  bool isAccepted;
  bool isCancelled;
  bool isDelivered;
  DateTime createdAt;

  Order(
      {this.id,
      required this.customerId,
      required this.productIds,
      required this.deliveryFee,
      required this.subtotal,
      required this.isAccepted,
      required this.isCancelled,
      required this.isDelivered,
      required this.total,
      required this.createdAt});

  Order copyWith(
      {final String? id,
      final int? customerId,
      final List<String>? productIds, //List<int>? productIds,
      final double? deliveryFee,
      final double? subtotal,
      final double? total,
      bool? isAccepted,
      bool? isCancelled,
      bool? isDelivered,
      DateTime? createdAt}) {
    return Order(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        productIds: productIds ?? this.productIds,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        subtotal: subtotal ?? this.subtotal,
        total: total ?? this.total,
        isAccepted: isAccepted ?? this.isAccepted,
        isCancelled: isCancelled ?? this.isCancelled,
        isDelivered: isDelivered ?? this.isDelivered,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      //  'id': id,
      'customerId': customerId,
      'productIds': productIds,
      'deliveryFee': deliveryFee,
      'subtotal': subtotal,
      'total': total,
      'isAccepted': isAccepted,
      'isCancelled': isCancelled,
      'isDelivered': isDelivered,
      'createdAt': createdAt
    };
  }

  factory Order.fromJson(String source) => Order.fromMap(json.decode(source));

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
        //id: map['id'],
        customerId: map['customerId'],
        productIds: map['productIds'],
        deliveryFee: map['deliveryFee'],
        subtotal: map['subtotal'],
        total: map['total'],
        isAccepted: map['isAccepted'],
        isCancelled: map['isCancelled'],
        isDelivered: map['isDelivered'],
        createdAt: map['createdAt']);
  }

  factory Order.fromSnapShot(DocumentSnapshot snap) {
    return Order(
        id: snap.id,
        customerId: snap['customerId'],
        productIds: List<String>.from(
            snap['productIds']), //List<int>.from(snap['productIds']),
        deliveryFee: double.parse(snap['deliveryFee']),
        subtotal: double.parse(snap['subtotal']),
        total: double.parse(snap['total']),
        isAccepted: snap['isAccepted'],
        isCancelled: snap['isCancelled'],
        isDelivered: snap['isDelivered'],
        createdAt: snap['createdAt'].toDate());
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        id,
        customerId,
        productIds,
        deliveryFee,
        subtotal,
        isAccepted,
        isCancelled,
        isDelivered,
        total,
        createdAt
      ];
}
