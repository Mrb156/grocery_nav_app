//import 'dart:html';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/screens/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Products> termekek = [
  // (Products(id: 1, price: 500, name: 'Tej 2,8%', db: 0)),
  // (Products(id: 2, price: 1500, name: 'Sajt 700g', db: 0)),
  // (Products(id: 3, price: 600, name: 'Coca Cola 2l', db: 0)),
  // (Products(id: 4, price: 350, name: 'Margarin', db: 0)),
  // (Products(id: 5, price: 120, name: 'Kifli', db: 0)),
  // (Products(id: 6, price: 560, name: 'Szalámi', db: 0)),
  // (Products(id: 7, price: 980, name: 'Sonka', db: 0)),
  // (Products(id: 8, price: 660, name: 'Jégsaláta', db: 0)),
  // (Products(id: 9, price: 200, name: 'Croissant', db: 0)),
  // (Products(id: 10, price: 200, name: 'Sajtos pogácsa', db: 0)),
  // (Products(id: 11, price: 570, name: 'Mizo Kakaó', db: 0)),
  // (Products(id: 12, price: 810, name: 'WC papír', db: 0)),
  // (Products(id: 13, price: 500, name: 'Tej 1,5%', db: 0))
];

List<bool> userChecked = [];
List<int> db = [];
int osszeg = 0;
List<int> preOsszeg = [];
int szamlalo = 0;
List<Products> savedList = [];
String searchText = '';
TextEditingController _searchController = TextEditingController();

void decrement(int szam) {
  if (szam > 0) {
    szam = szam - 1;
  }
}

void save(int prc, int db, String product, int id) {
  savedList.add(Products(db: db, name: product, price: prc, id: id));
}

void increment(int szam) {
  szam = szam + 1;
}

void check() {
  for (var i = 0; i < termekek.length; i++) {
    userChecked.add(false);
    db.add(0);
    preOsszeg.add(0);
  }
}

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('termékek');
  List<DocumentSnapshot> prod = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            //return const Center(child: CircularProgressIndicator());
            prod = snapshot.data!.docs;
            if (termekek.isEmpty) {
              for (var i = 0; i < prod.length; i++) {
                termekek.add(Products(
                    id: prod[i].get("id"),
                    name: prod[i].get("name"),
                    price: prod[i].get("price"),
                    db: prod[i].get("db")));
              }
            }
            check();
            if (searchText.length > 0) {
              prod = prod.where((element) {
                return element
                    .get('name')
                    .toString()
                    .toLowerCase()
                    .contains(searchText.toLowerCase());
              }).toList();
              termekek = [];
              for (var i = 0; i < prod.length; i++) {
                termekek.add(Products(
                    id: prod[i].get("id"),
                    name: prod[i].get("name"),
                    price: prod[i].get("price"),
                    db: prod[i].get("db")));
              }
              check();
            }
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.amber,
                title: const Text('Lista'),
                actions: <Widget>[
                  IconButton(
                    onPressed: (() {
                      szamlalo++;
                    }),
                    icon: const Icon(Icons.save),
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: (() {
                      szamlalo++;
                    }),
                    icon: const Icon(Icons.file_open),
                    color: Colors.black,
                  )
                ],
              ),
              body: ListView.builder(
                padding: const EdgeInsets.only(bottom: 56, top: 40),
                itemCount: termekek.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTileCard(
                    initialPadding: EdgeInsets.all(12.0),
                    expandedColor: Colors.amber,
                    expandedTextColor: Colors.black87,
                    baseColor: Colors.amber,
                    subtitle: Text(termekek[index].price.toString() + ' Ft'),
                    trailing: Checkbox(
                        value: userChecked[index],
                        onChanged: (bool? value) {
                          setState(() {
                            userChecked[index] = value!;
                            if (userChecked[index] == true) {
                              termekek[index].db = 1;
                              osszeg = osszeg + termekek[index].price * 1;
                              preOsszeg[index] = termekek[index].price * 1;
                            } else if (userChecked[index] == false) {
                              termekek[index].db = 0;
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
                                  if (termekek[index].db <= 0) {
                                  } else {
                                    termekek[index].db--;
                                    osszeg = osszeg - termekek[index].price;
                                  }
                                  if (termekek[index].db == 0) {
                                    userChecked[index] = false;
                                  }
                                });
                              },
                              child: const Icon(Icons.remove)),
                          Text(
                            termekek[index].db.toString(),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  termekek[index].db++;
                                  if (termekek[index].db > 0) {
                                    userChecked[index] = true;
                                  }

                                  osszeg = osszeg + termekek[index].price;
                                  preOsszeg[index] = termekek[index].price *
                                      termekek[index].db;
                                });
                              },
                              child: const Icon(Icons.add)),
                        ],
                      )
                    ],
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  if (savedList.isNotEmpty) {
                    int hossz = savedList.length;
                    for (int i = 0; i < hossz; i++) {
                      savedList.removeLast();
                    }
                  }
                  for (int i = 0; i < termekek.length; i++) {
                    if (userChecked[i] == true) {
                      save(termekek[i].price, termekek[i].db, termekek[i].name,
                          termekek[i].id);
                    }
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => Chart(savedList))));
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
