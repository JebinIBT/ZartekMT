
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String count;
  final int price;
  final double calories;
  final int dishtype;


  Product( {
    required this.id,
    required this.name,
    required this.count,
    required this.price,
    required this.calories,
    required this.dishtype,

  });

  Product.fromSnapshot(DocumentSnapshot snapshot,  )
      : id = snapshot.id,
        name = snapshot['name'],
        dishtype = snapshot['dishtype'],
        count = snapshot['count'],
        calories = snapshot['calories']?.toDouble() ?? 0.0,
        price = snapshot['price'];

}
