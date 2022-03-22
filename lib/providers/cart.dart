import 'package:flutter/widgets.dart';

// this is simple:
// a CartItem contains only one "Product" with different quantities.
// Ex: we can have a cartItem that has 1 product "Shoes" with 2 quantities (i.e 2 pairs of shoes).

/*
 * CartItem is an item of the cart Class that contains a product with different quantities.
 * The Cart class is a class that stores
 * a map of CartItem identified by their product id
 * this is useful because when we want to add a new cart item or modify an existing one
 * we only need its product id.
 * of course every CartItem has its own id different from its product id.
 * but we are working with products in our app so it makes sence to identify CartItems by their product id.
 */

class CartItem {
  final String id; // the id of the cart item not the product it belongs to.
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  // we could have a list of cart item
  // but we will map every cart item to the id of the product it belongs to.
  // because if we have a product in a cart, we only want to increase its quantity.

  // a map from product id to cart item.
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int get totalNumberProducts {
    int total = 0;
    _items.forEach((key, value) {
      total += value.quantity;
    });

    return total;
  }

  // this function adds a new CartItem to the map
  // if the CartItem exists, it modifies its product quantity.
  // otherwise it adds a new entry to the map having the newly created CartItem.
  void addCartItem(String productId, double price, String title) {
    // quantity is always 1, this means we can only add one item at a time.

    // checking if a product is existing in the cart item.
    // if it is we increase its quantity.
    if (_items.containsKey(productId)) {
      // change the quantity:
      // i.e: replace the oldCartItem with the new one. that have (quantity + 1) products.
      _items.update(
        productId,
        (oldCartItem) => CartItem(
          id: oldCartItem.id,
          title: oldCartItem.title,
          price: oldCartItem.price,
          quantity: oldCartItem.quantity + 1,
        ),
      );
    } else {
      // add a new entry product.
      final CartItem newCartItem = CartItem(
        id: DateTime.now().toString(), // this is the id of the cart item.
        title: title,
        quantity: 1,
        price: price,
      );
      _items.putIfAbsent(productId, () => newCartItem);
    }

    notifyListeners();
  }

  void removeCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
