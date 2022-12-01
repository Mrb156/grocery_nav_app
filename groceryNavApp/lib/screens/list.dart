//import 'dart:html';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/screens/chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List<Products> termekek = [];
List<Products> filtered = [];
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

void save(int prc, int db, String product, int id, bool checked) {
  if (!savedList.contains(
      Products(db: db, name: product, price: prc, id: id, checked: checked))) {
    savedList.add(
        Products(db: db, name: product, price: prc, id: id, checked: checked));
  }
}

void remove(int prc, int db, String product, int id, bool checked) {
  savedList.remove(
      Products(db: db, name: product, price: prc, id: id, checked: checked));
}

void increment(int szam) {
  szam = szam + 1;
}

void check() {
  for (var i = 0; i < termekek.length; i++) {
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
  void initState() {
    filtered = termekek;
    super.initState();
  }

  void _runfilter(String keyword) {
    List<Products> results = [];
    if (keyword.isEmpty) {
      results = termekek;
    } else {
      results = termekek
          .where((termek) =>
              termek.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      filtered = results;
    });
  }

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
                    id: prod[i].get("szektor"),
                    name: prod[i].get("name"),
                    price: prod[i].get("price"),
                    db: prod[i].get("db"),
                    checked: false));
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
                    db: prod[i].get("db"),
                    checked: false));
              }
              check();
            }
            return Scaffold(
              appBar: AppBar(
                foregroundColor: Colors.black,
                backgroundColor: Colors.amber,
                title: SizedBox(
                  height: 40,
                  child: TextField(
                    autofocus: false,
                    controller: _searchController,
                    onChanged: (value) => _runfilter(value),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.amber[100],
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none)),
                  ),
                ),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.only(bottom: 56, top: 40),
                itemCount: filtered.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTileCard(
                    initialPadding: EdgeInsets.all(12.0),
                    initialElevation:
                        MediaQuery.of(context).size.height * 0.004,
                    expandedColor: Colors.amber,
                    expandedTextColor: Colors.black87,
                    // baseColor: Color.fromARGB(255, 255, 255, 255),
                    subtitle: Text(filtered[index].price.toString() + ' Ft'),
                    trailing: Checkbox(
                        value: filtered[index].checked,
                        onChanged: (bool? value) {
                          setState(() {
                            filtered[index].checked = value!;
                            if (filtered[index].checked == true) {
                              filtered[index].db = 1;
                              osszeg = osszeg + filtered[index].price * 1;
                              preOsszeg[index] = filtered[index].price * 1;
                              save(
                                  filtered[index].price,
                                  filtered[index].db,
                                  filtered[index].name,
                                  filtered[index].id,
                                  filtered[index].checked);
                            } else if (filtered[index].checked == false) {
                              filtered[index].db = 0;
                              osszeg = osszeg - preOsszeg[index];
                              remove(
                                  filtered[index].price,
                                  filtered[index].db,
                                  filtered[index].name,
                                  filtered[index].id,
                                  filtered[index].checked);
                            }
                          });
                        }),
                    title: Text(filtered[index].name),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (filtered[index].db <= 0) {
                                  } else {
                                    filtered[index].db--;
                                    osszeg = osszeg - filtered[index].price;
                                  }
                                  if (filtered[index].db == 0) {
                                    filtered[index].checked = false;
                                  }
                                });
                              },
                              child: const Icon(Icons.remove)),
                          Text(
                            filtered[index].db.toString(),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  filtered[index].db++;
                                  if (filtered[index].db > 0) {
                                    filtered[index].checked = true;
                                  }

                                  osszeg = osszeg + filtered[index].price;
                                  preOsszeg[index] = filtered[index].price *
                                      filtered[index].db;
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
                  // if (savedList.isNotEmpty) {
                  //   int hossz = savedList.length;
                  //   for (int i = 0; i < hossz; i++) {
                  //     savedList.removeLast();
                  //   }
                  // }
                  // for (int i = 0; i < filtered.length; i++) {
                  //   if (filtered[i].checked == true) {
                  //     save(filtered[i].price, filtered[i].db, filtered[i].name,
                  //         filtered[i].id, filtered[i].checked);
                  //   }
                  // }
                  if (!savedList.isEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => Chart(savedList))));
                  } else {
                    showDialog(
                        context: context,
                        builder: ((context) {
                          return AlertDialog(
                            title: const Text("Üres a bevásárlólistád!"),
                            content: const Text(
                                "Addig nem tudsz továbblépni, ameddig nem adtál hozzás emmit a listádhoz."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        }));
                  }
                },
              ),
              bottomNavigationBar: BottomAppBar(
                  color: Colors.amber,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.01),
                    child: Text(
                      'Végösszeg: ' + osszeg.toString() + 'Ft',
                      textAlign: TextAlign.center,
                    ),
                  )),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
