import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grocery_nav_app/screens/home.dart';
import 'package:grocery_nav_app/screens/nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<int> list = [19, 23, 16,10,15, 5,6,4,12,3,2,10,15];
  void generate() {
    for (var i = 0; i < 23; i++) {
      var num = Random().nextInt(22) + 1;
      if (!list.contains(num) && num != 21) {
        list.add(num);
      }
    }
  }

  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    generate();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      home: Navigation(list),
    );
  }
}
