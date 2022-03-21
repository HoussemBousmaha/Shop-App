import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // change notifier provider let's us provide a class to which
    // you can then listen to its changes in child widgets
    // and whenever that class updates the child widgets which are listening
    // will get rebuild.
    return ChangeNotifierProvider(
      // setting up a provider to the MyApp widget.
      create: (context) {
        return Products();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Lato',
          primarySwatch: Colors.purple,
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
        },
      ),
    );
  }
}
