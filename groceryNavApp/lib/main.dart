import 'package:flutter/material.dart';
import 'package:grocery_nav_app/screens/home.dart';
import 'package:grocery_nav_app/screens/nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: Navigation(const [1, 5, 3, 6, 8, 19, 14, 9, 2, 11]),
    );
  }
}
