import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    Key? key,
  }) : super(key: key);

  static const routeName = '/product-detail/';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // the productId is passed from the ProductGridItem to the ProductDetailsScreen
    // via the constructor then we use the provider package to find the item by its Id.
    final product = Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Text(product.title),
      ),
    );
  }
}
