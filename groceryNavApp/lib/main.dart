import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';
//import 'package:grocery_nav_app/screens/home.dart';
import 'package:grocery_nav_app/screens/nav.dart';
import 'package:grocery_nav_app/screens/list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<int> list = [19, 23, 16];
  void generate() {
    for (var i = 1; i < 23; i++) {
      list.add(i);
      var num = Random().nextInt(22) + 1;
      if (!list.contains(num) && num != 21) {}
    }
  }

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //generate();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: Navigation([Products(db: 0, name: "product", price: 2, id: 1),Products(db: 0, name: "product", price: 2, id: 19)]),
    );
  }
}
