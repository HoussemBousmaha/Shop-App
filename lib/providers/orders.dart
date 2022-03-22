import 'package:flutter/material.dart';

import './cart.dart';

class OrderItem {
  OrderItem({
    required this.id,
    required this.amount,
    required this.items,
    required this.storingTime,
  });

  final String id;
  final double amount;
  final List<CartItem> items;
  final DateTime storingTime;
}

// every OrderItem has:
// 1- List of Cart Items (i.e: a list of products with different amounts.)
// 2- a unique id
// 3- total amount of the order (sum of amounts of all CartItems)
// 4- the time we stored the order.

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get items {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems) {
    double total = 0;
    for (var cartItem in cartItems) {
      total += cartItem.price * cartItem.quantity;
    }

    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        items: cartItems,
        storingTime: DateTime.now(),
      ),
    );

    notifyListeners();
  }
}
