import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/provider.dart';
import '../Login/login.dart';
import 'breakfastScreen.dart';
import 'cartScreen.dart';
import 'lunch.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () {
      Provider.of<RestaurantProvider>(context, listen: false)
          .fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "Breakfast"),
              Tab(text: "Lunch"),
              Tab(text: "Dinner"),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: user == null
                    ? Center(
                        child: Text("No user logged in",
                            style: TextStyle(color: Colors.white)))
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage('assets/img_1.png'),
                            ),
                            Text(
                              "${user!.displayName ?? 'Anonymous'}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "${user!.uid}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Log out"),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BreakfastScreen(),
            LunchScreen(),
            LunchScreen(),
          ],
        ),
      ),
    );
  }
}
