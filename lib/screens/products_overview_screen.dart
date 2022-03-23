import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';

import './product_details_screen.dart';
import './cart_screen.dart';

import '../widgets/drawer.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    // this is the main screen
    // it is a grid of product items or card
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(child: Text('only favorites'), value: FilterOptions.favorites),
              const PopupMenuItem(child: Text('show all'), value: FilterOptions.all),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badge(
                child: child!,
                value: cart.totalNumberProducts.toString(),
                color: cart.items.isEmpty ? null : Colors.purple,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.card_travel),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      // gridview.builder optimizes long grid views with multiple items
      // where we do not know how many items we have.
      // It renders items that are on the screen only.
      body: ProductsGrid(_showFavoritesOnly),

      // this is a side drawer to switch between
      // products overview screen and orders screen.
      drawer: const AppDrawer(),
    );
  }
}

// ProductsGrid is GridView of ProductGridItems
class ProductsGrid extends StatelessWidget {
  const ProductsGrid(this.showFavoritesOnly, {Key? key}) : super(key: key);

  // this property is used to filter products.
  final bool showFavoritesOnly;

  @override
  Widget build(BuildContext context) {
    // this is a listener to changes in the Products class.
    // whenever a change happend in that class, this build function will be called.
    // and therefor we fetch the last data from our Products class.
    // here we are listening to changes in the list of products. (items)
    final products = showFavoritesOnly ? Provider.of<Products>(context).favoriteItems : Provider.of<Products>(context).items;

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
    final cart = Provider.of<Cart>(context, listen: false);
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
          // Consumer to listen to changes in the isFavorite state.
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
            onPressed: () {
              // adding a new cart item having this product.
              cart.addCartItem(product);
            },
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
            // going to the product details screen and passing the product in the fly
            // to display its information the product details screen.
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: product,
            );
          },
          child: Image.network(product.imageUrl, fit: BoxFit.fitHeight), // image of a product.
        ),
      ),
    );
  }
}

// this is the little widget at the top-right.
class Badge extends StatelessWidget {
  const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: color ?? Colors.deepOrange),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ),
        )
      ],
    );
  }
}
