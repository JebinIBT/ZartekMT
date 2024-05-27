import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'homepage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

late List<DocumentSnapshot> allProducts = [];
late List<DocumentSnapshot> displayedProducts = [];
double _totalPrice = 0.0;

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  void getAllProducts() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('uid', isEqualTo: uid)
          .get();

      setState(() {
        allProducts = querySnapshot.docs;
        displayedProducts = List.from(allProducts);
        calculateTotalPrice();
      });
    }
  }

  void calculateTotalPrice() {
    _totalPrice = 0.0;
    for (var product in displayedProducts) {
      Map<String, dynamic> productData = product.data() as Map<String, dynamic>;
      int count = int.tryParse(productData['count'].toString()) ?? 0;
      double price = double.tryParse(productData['price'].toString()) ?? 0.0;
      _totalPrice += count * price;
    }
  }

  void deleteProduct(DocumentSnapshot product) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .delete();
      setState(() {
        displayedProducts.remove(product);
        calculateTotalPrice();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete product: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Summary',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
        child: Column(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${displayedProducts.length} Dishes  ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            displayedProducts.isNotEmpty
                ? Flexible(
                    child: ListView.builder(
                      itemCount: displayedProducts.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> productData =
                            displayedProducts[index].data()
                                as Map<String, dynamic>;
                        int count =
                            int.tryParse(productData['count'].toString()) ?? 0;
                        double price =
                            double.tryParse(productData['price'].toString()) ??
                                0.0;
                        double totalAmount = count * price;
                        return Column(
                          children: [
                            ListTile(
                              leading: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                    ),
                                  ),
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: productData['dishType'] == 3
                                          ? Colors.red
                                          : Colors.green,
                                      border: Border.all(
                                          color: Colors.white, width: 1),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                productData['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              subtitle: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('INR ${productData['price']}'),
                                      SizedBox(height: 5),
                                      Text('${productData['calories']} cal'),
                                    ],
                                  ),
                                  SizedBox(width: 30),
                                  Container(
                                    height: 30,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade900,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$count',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'INR ${totalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        deleteProduct(displayedProducts[index]),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        4, // Adjust the number of shimmer placeholders as needed
                    itemBuilder: (context, index) {
                      return ShimmerEffect();
                    },
                  ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "INR ${_totalPrice.toStringAsFixed(1)}",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Successfully Order placed",
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Poppins')),
                  ),
                );
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.green.shade900,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    'Place Order ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 200,
              width: 190, // Added width for the red container
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
            ),
            SizedBox(width: 10),
            Container(
              height: 200,
              width: 190, // Added width for the red container
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
