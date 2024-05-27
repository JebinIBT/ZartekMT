import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zartemachinetest/firebase_options.dart';

import 'RestaurantsApp/Provider/provider.dart';
import 'RestaurantsApp/Views/Login/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RestaurantProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
              home:  LoginScreen())


      ));
}

