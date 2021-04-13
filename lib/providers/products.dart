import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Honey Lavendar',
    //     description: 'Honey Lavender Cold Brew Latte.',
    //     price: 10.99,
    //     imageUrl:
    //         'https://i.pinimg.com/564x/8b/72/68/8b7268ea53546a83acb6d804ed4a97a6.jpg'),
    // Product(
    //   id: 'p2',
    //   title: 'Blue Stone',
    //   description: 'Hot Coffee on The Big Island of Hawaii',
    //   price: 13.99,
    //   imageUrl:
    //       'https://i.pinimg.com/564x/49/d9/e4/49d9e43777d79668b4d2c05d97b0696e.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Dalgona',
    //   description: 'Indian Whipped Coffee',
    //   price: 11.99,
    //   imageUrl:
    //       'https://i.pinimg.com/564x/11/6c/16/116c165e75b622ef5e683cd3b1567c5e.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Frozen Samoa',
    //   description:
    //       'Loaded with coconut, chocolate, caramel, and cold brew coffee. The ultimate!',
    //   price: 16.99,
    //   imageUrl:
    //       'https://i.pinimg.com/564x/e6/e3/bd/e6e3bd8ec20ced2cf3d2c1791e9f7835.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

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
  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'fancy-caffeine-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'fancy-caffeine-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          'fancy-caffeine-default-rtdb.firebaseio.com', '/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void deleteProduct(String id) async {
    final url = Uri.https(
        'fancy-caffeine-default-rtdb.firebaseio.com', '/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
