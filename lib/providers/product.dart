// this class is a blue print for our products
// with every product instance we must specify its id, title, description, price and imageUrl

import 'package:flutter/widgets.dart';

class Product with ChangeNotifier {
  // final because we excpect to get these properties when ever a new product is created
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl; // image of each product is stored in a server not as an asset. (one app version)
  bool isFavorite; // not final because it is initially false, we will modify it later.

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void changeFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
