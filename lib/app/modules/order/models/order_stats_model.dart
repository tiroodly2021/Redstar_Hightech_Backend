import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderStats {
  final DateTime dateTime;
  final int index;
  final int orders;
  charts.Color? barColor;

  OrderStats(
      {required this.dateTime, required this.index, required this.orders}) {
    barColor = charts.ColorUtil.fromDartColor(Colors.black);
  }

  factory OrderStats.fromSnapshot(DocumentSnapshot snap, int index) {
    return OrderStats(
        dateTime: snap['dateTime'].toDate(),
        index: index,
        orders: snap['orders']);
  }

  static final List<OrderStats> orderStats = [
    OrderStats(dateTime: DateTime.now(), index: 10, orders: 3),
    OrderStats(dateTime: DateTime.now(), index: 10, orders: 3),
    OrderStats(dateTime: DateTime.now(), index: 7, orders: 13),
    OrderStats(dateTime: DateTime.now(), index: 78, orders: 4),
    OrderStats(dateTime: DateTime.now(), index: 19, orders: 6),
    OrderStats(dateTime: DateTime.now(), index: 14, orders: 5),
  ];
}
