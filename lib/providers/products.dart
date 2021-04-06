import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Honey Lavendar',
        description: 'Honey Lavender Cold Brew Latte.',
        price: 10.99,
        imageUrl:
            'https://i.pinimg.com/564x/8b/72/68/8b7268ea53546a83acb6d804ed4a97a6.jpg'),
    Product(
      id: 'p2',
      title: 'Blue Stone',
      description: 'Hot Coffee on The Big Island of Hawaii',
      price: 13.99,
      imageUrl:
          'https://i.pinimg.com/564x/49/d9/e4/49d9e43777d79668b4d2c05d97b0696e.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Dalgona',
      description: 'Indian Whipped Coffee',
      price: 11.99,
      imageUrl:
          'https://i.pinimg.com/564x/11/6c/16/116c165e75b622ef5e683cd3b1567c5e.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Frozen Samoa',
      description:
          'Loaded with coconut, chocolate, caramel, and cold brew coffee. The ultimate!',
      price: 16.99,
      imageUrl:
          'https://i.pinimg.com/564x/e6/e3/bd/e6e3bd8ec20ced2cf3d2c1791e9f7835.jpg',
    ),
  ];

  var _showFavoritesOnly = false;

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItms {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();

  // }

  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct){
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex >=0 ){
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id){
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
