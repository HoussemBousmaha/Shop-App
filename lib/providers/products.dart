import 'package:flutter/material.dart';
import 'product.dart';

// change notifier is related to the "inherited widget" which
// the provider package uses under the scene

/* 
 
 * Working with the Provider state management technique
 *
 * - we add a provider to some ancestor widget which has one or more descendant widget that 
 *   its state will be affected whenever a change in the provider (Products class) occurs.
 * 
 * - then in the descendant widgets we add a listener that listens to provider changes
 *   in the ancestor widget, and whenever we make a change. we notify our listeners.
 *
 * Using this technique we can avoid passing data via constructors.
 * 
 * imagine we have a widget "A1" that has a child widget "B1"
 * "B1" has a child "C1" and to pass data (State) from "A1" to "C1". 
 * the problem with passing data via constructors is that we have to pass data to "B1"
 * then pass it to "C1" but we don't really need that data in b1.
 * 
 * So the provider package solves this problem for us.
 * We can add a provider to "A1" and then add a listener to "C1"
 * when ever we make a change in the provider we will notify our Listeners 
 * in this case we only have one listener "C1"
 * after notifying "C1" that some changes happened, the build method of "C1" will be triggered.
 * 
 * 
 */

/* 
 * Difference between Mixin and Extends:
 * - Extends Gives the Type to the child class
 *   so the child class will have 2 Types: its type and the parent class type.
 * - Logically: When using Extends your are also referring that there is a strong
 *   connection between the parent and the child classes 
 *   (Ex: Mammal and Person are two classes that have a strong connection.)
 * 
 * - Mixin do not Give the Type to the child class.
 * 
 * - you use Mixin when there is less connection between parent and child classes.
 *   (Ex: Person With "Moving" Mixin. not only a person can move, so it is better to use a Mixin.)
 * 
 * IN Dart language:
 * - You can only Extends one class, but with Mixin you can Mixin multiple classes
 *   for the same child class.
 * 
 * 
 */

/*
 * Typically, when working with the Provider package, 
 * you provide objects based on your own custom classes.

 * This makes sense because you can implement the ChangeNotifier mixin
 * in your classes to then trigger notifyListeners() whenever you want
 * to update all places in your app that listen to your data.

 * But you're not limited to providing objects
 * - you can provide ANY kind of value: 
 * (lists, numbers, strings, objects without ChangeNotifier mixing, ...).

 * Example:

 * Provider<String>(create: (ctx) => 'I am a String', child: ...);

 * You might wonder, how this text can change though - it's a constant text after all.
 * It certainly doesn't implement the ChangeNotifier mixin
 * (the String class, which is built-into Dart, indeed doesn't - just like numbers, booleans etc.).

 * It's important to note, that the above snippet uses Provider, NOT ChangeNotifierProvider. 
 * ChangeNotifierProvider indeed only works with objects based on classes that use the ChangeNotifier mixin.
 * And this is the most common use-case, because you typically want to be your global data changeable
 * (and have the app UI react to that).

 * But in case you just want to provide some global 
 * (constant) value which you can then conveniently use like this:

 * print(Provider.of<String>(context));  * prints 'Hi, I am a text!'; does never update!
 * you can do that.

 */

class Products with ChangeNotifier {
  final List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl: 'https://static-01.daraz.pk/p/5936a1d46f92a49dc4b7b7a630e28b9d.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl: 'https://stylesatlife.com/wp-content/uploads/2019/05/Peg-trousers.jpg.webp',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl: 'https://thumbs.dreamstime.com/b/yellow-knitted-scarf-18952858.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl: 'https://sc04.alicdn.com/kf/Uba51f66e1b464d1daee2eb5711998b45f.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((product) => product.isFavorite).toList();
  }
}
