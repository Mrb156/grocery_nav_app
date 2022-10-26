//import 'dart:html';
import 'package:expansion_tile_card/expansion_tile_card.dart';
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

List<bool> userChecked = [];
List<int> db = [];
int osszeg = 0;
List<int> preOsszeg = [];
int szamlalo = 0;

void decrement(int szam) {
  if (szam > 0) {
    szam = szam - 1;
  }
}

void increment(int szam) {
  szam = szam + 1;
}

class _ListaState extends State<Lista> {
  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < termekek.length; i++) {
      userChecked.add(false);
      db.add(0);
      preOsszeg.add(0);
    }

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Lista'),
            Text('A lista összege: ' + osszeg.toString() + 'Ft')
          ],
        ),
        foregroundColor: Colors.amber[300],
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue[300],
      ),
      body: ListView.builder(
        itemCount: termekek.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTileCard(
            initialPadding: EdgeInsets.all(12.0),
            expandedColor: Colors.amber[500],
            expandedTextColor: Colors.black87,
            baseColor: Colors.amber[300],
            subtitle: Text(termekek[index].price.toString() + ' Ft'),
            trailing: Checkbox(
                value: userChecked[index],
                onChanged: (bool? value) {
                  setState(() {
                    userChecked[index] = value!;
                    if (userChecked[index] == true) {
                      db[index] = 1;
                      osszeg = osszeg + termekek[index].price * 1;
                      preOsszeg[index] = termekek[index].price * 1;
                    } else if (userChecked[index] == false) {
                      db[index] = 0;
                      osszeg = osszeg - preOsszeg[index];
                    }
                  });
                }),
            title: Text(termekek[index].name),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (db[index] <= 0) {
                          } else {
                            db[index]--;
                            osszeg = osszeg - termekek[index].price;
                          }
                          if (db[index] == 0) {
                            userChecked[index] = false;
                          }
                        });
                      },
                      child: const Icon(Icons.remove)),
                  Text(
                    db[index].toString(),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          db[index]++;
                          if (db[index] > 0) {
                            userChecked[index] = true;
                          }

                          osszeg = osszeg + termekek[index].price;
                          preOsszeg[index] = termekek[index].price * db[index];
                        });
                      },
                      child: const Icon(Icons.add))
                ],
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('Útvonal generálása'),
          onPressed: () {
            szamlalo++;
          }),
    );
  }
}
