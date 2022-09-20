import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista a termékekről'),),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){}, label: Text('Tovább')),
    );
  }
}


