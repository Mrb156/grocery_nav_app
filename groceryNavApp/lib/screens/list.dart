//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';

List<Products> termekek = [
  (Products(id: 1, price: 500, name: 'Tej 2,8%')),
  (Products(id: 2, price: 1500, name: 'Sajt 700g')),
  (Products(id: 3, price: 600, name: 'Coca Cola 2l')),
  (Products(id: 4, price: 350, name: 'Margarin')),
  (Products(id: 5, price: 120, name: 'Kifli')),
  (Products(id: 6, price: 560, name: 'Szalámi')),
  (Products(id: 7, price: 980, name: 'Sonka')),
  (Products(id: 8, price: 660, name: 'Jégsaláta')),
  (Products(id: 9, price: 200, name: 'Croissant')),
  (Products(id: 10, price: 200, name: 'Sajtos pogácsa')),
  (Products(id: 11, price: 570, name: 'Mizo Kakaó')),
  (Products(id: 12, price: 810, name: 'WC papír')),
  (Products(id: 13, price: 500, name: 'Tej 1,5%'))
];

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

bool isChecked = false;

class _ListaState extends State<Lista> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Lista')),
          backgroundColor: const Color.fromRGBO(89, 76, 34, 1.0),
        ),
        body: ListView.builder(
          itemCount: termekek.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(termekek[index].name +
                  '    ' +
                  termekek[index].price.toString() +
                  'Ft'),
              trailing: Checkbox(
                value: isChecked,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
            );
          },
        ));
  }
}
/*Text(termekek[index].name +
                    '    ' +
                    termekek[index].price.toString() +
                    'Ft')*/
