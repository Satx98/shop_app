import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  var _orders = <OrderItem>[];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(
    List<CartItem> cartProducts,
    double total,
  ) async {
    const url = 'https://flutter-project-iamgood.firebaseio.com/orders.json';

    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'price': cartItem.price,
                    'quantity': cartItem.quantity,
                    'title': cartItem.title,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
