import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Model/datamodel.dart';
import '../../Model/product_model.dart';
import '../../Provider/provider.dart';

class BreakfastScreen extends StatefulWidget {
  const BreakfastScreen({super.key});

  @override
  State<BreakfastScreen> createState() => _BreakfastScreenState();
}

class _BreakfastScreenState extends State<BreakfastScreen> {
  Map<String, int> _dishCounters = {};

  void _incrementCounter(String dishId) {
    setState(() {
      _dishCounters[dishId] = (_dishCounters[dishId] ?? 0) + 1;
    });
  }

  void _decrementCounter(String dishId) {
    setState(() {
      if ((_dishCounters[dishId] ?? 0) > 0) {
        _dishCounters[dishId] = (_dishCounters[dishId] ?? 0) - 1;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dishCounters.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, child) {
          if (restaurantProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (restaurantProvider.errorMessage != null) {
            return Center(
                child: Text('Error: ${restaurantProvider.errorMessage}'));
          } else if (restaurantProvider.restaurants.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: restaurantProvider.restaurants.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = restaurantProvider.restaurants[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Column(
                    children: restaurant.tableMenuList.map((menu) {
                      return menu.menuCategory == 'Breakfast'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: menu.categoryDishes.map((dish) {
                                String dishId =
                                    dish.dishId; // dishId is a string
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 18,
                                                  height: 18,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 1),
                                                  ),
                                                ),
                                                Container(
                                                  width: 14,
                                                  height: 14,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: dish.dishType == 3
                                                        ? Colors.red
                                                        : Colors.green,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 70)
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dish.dishName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'INR ${dish.dishPrice.toString()}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                      '${dish.dishCalories.toString()} calories',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                dish.dishDescription,
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () =>
                                                              _decrementCounter(
                                                                  dishId),
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color: Colors.white,
                                                          ),
                                                          iconSize: 20,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          constraints:
                                                              BoxConstraints(),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          '${_dishCounters[dishId] ?? 0}',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(width: 10),
                                                        IconButton(
                                                          onPressed: () =>
                                                              _incrementCounter(
                                                                  dishId),
                                                          icon: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                          ),
                                                          iconSize: 20,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          constraints:
                                                              BoxConstraints(),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        final User? user =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser;
                                                        String uid = user!.uid;
                                                        final product = Product(
                                                          id: dish.dishId,
                                                          name: dish.dishName,
                                                          count: _dishCounters[
                                                                  dishId]
                                                              .toString(),
                                                          calories:
                                                              dish.dishCalories,
                                                          price: dish.dishPrice
                                                              .toInt(),
                                                          dishtype:
                                                              dish.dishType,
                                                        );
                                                        restaurantProvider
                                                            .addProduct(
                                                                product, uid);

                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                          backgroundColor:
                                                              Colors.green,
                                                          content: Text(
                                                              "Sucessfully added to cart",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      'Poppins')),
                                                        ));
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        height: 30,
                                                        width: 135,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .red.shade300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                  Icons
                                                                      .add_shopping_cart,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .white,
                                                                )),
                                                            Text(
                                                              "Add to cart",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Image.network(
                                          dish.dishImage,
                                          width: 65,
                                          height: 65,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    dish.addonCat.isNotEmpty
                                        ? Text("Customizations available",
                                            style: TextStyle(color: Colors.red))
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(),
                                  ],
                                );
                              }).toList(),
                            )
                          : SizedBox.shrink();
                    }).toList(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
