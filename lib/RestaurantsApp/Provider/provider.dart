import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Model/datamodel.dart';
import '../Model/product_model.dart';

class RestaurantProvider with ChangeNotifier {
  List<Restaurant> _restaurants = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Restaurant> get restaurants => _restaurants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRestaurants() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
          'https://run.mocky.io/v3/eed9349e-db58-470c-ae8c-a12f6f46c207'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load restaurants';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isProLoading = false;
  String? _proerrorMessage;

  bool get isProLoading => _isProLoading;
  String? get proerrorMessage => _proerrorMessage;

  Future<void> addProduct(Product product, String uid) async {
    final CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    _isProLoading = true;
    _proerrorMessage = null;
    notifyListeners();

    try {
      await products.doc(product.id).set({
        'id': product.id,
        'name': product.name,
        'count': product.count,
        'calories': product.calories,
        'price': product.price,
        'dishType': product.dishtype,
        'uid': uid,
      });
    } catch (e) {
      _proerrorMessage = e.toString();
    } finally {
      _isProLoading = false;
      notifyListeners();
    }
  }
}
