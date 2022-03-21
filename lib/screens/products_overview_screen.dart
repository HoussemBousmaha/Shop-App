import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_details_screen.dart';
import '../providers/products.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    // this is the main screen
    // it is a grid of product items or card
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          )
        ],
      ),
      // gridview.builder optimizes long grid views with multiple items
      // where we do not know how many items we have.
      // It renders items that are on the screen only.
      body: const ProductsGrid(),
    );
  }
}

// ProductsGrid is GridView of ProductGridItems
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this is a listener to changes in the Products class.
    // whenever a change happend in that class, this build function will be called.
    // and therefor we fetch the last data from our Products class.
    // here we are listening to changes in the list of products. (items)
    final products = Provider.of<Products>(context).items.where((product) => !product.isFavorite).toList();
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      // griddelegate argument specify how the grid should be structured
      // that mean how many columns it should have.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, i) {
        // passing the products to the product grid item via constructors is recommended.
        // no need for provider technique
        // because this is a direct child and we need the product data in it.
        return ChangeNotifierProvider.value(
          value: products[i],
          child: const ProductGridItem(),
        );
      },
    );
  }
}

// ProductGridItem is a single GridItem containing the Product Information.
// for each GridItem we can navigate to the ProductDetails
class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // this grid tile bar will have:
        // - title of each product
        // - two buttons:
        //    1) switch from favorite product to not favorite product.
        //    2) add the product to the cart.
        footer: GridTileBar(
          // this is the 87% opacity black background color
          backgroundColor: Colors.black87,

          // this is the switch favorite status button.
          leading: Consumer<Product>(
            builder: (_, product, child) => IconButton(
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.changeFavoriteStatus();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 500),
                    content: Text('${product.title} is ${!product.isFavorite ? 'not' : ''} favorite!'),
                  ),
                );
              },
              color: product.isFavorite ? Colors.deepOrange : Colors.grey,
            ),
          ),

          // this is the title of the product.
          title: Text(
            product.title,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),

          // this is add product to the card button.
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Colors.deepOrange,
          ),
        ),

        // this is the main child of our grid tile
        // is contains a network image
        child: GestureDetector(
          // this onTap function is called when we tap the image.
          // it will take us to the product details screen
          // where we will show the details of each product.
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover), // image of a product.
        ),
      ),
    );
  }
}
