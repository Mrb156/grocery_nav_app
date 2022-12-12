import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/colors.dart';
import 'package:grocery_nav_app/screens/list.dart';
import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/screens/nav.dart';

class Chart extends StatefulWidget {
  List<Products> sList = [];
  Chart(this.sList);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  int ossz = 0;
  List<int> preosszeg = [];

  void calculate() {
    ossz = 0;
    for (int i = 0; i < widget.sList.length; i++) {
      ossz = ossz + widget.sList[i].price * widget.sList[i].db;
    }
  }

  void check() {
    for (var i = 0; i < termekek.length; i++) {
      preosszeg.add(0);
    }
  }

  int szamlalo = 0;

  @override
  Widget build(BuildContext context) {
    calculate();
    check();
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
          color: baseColor,
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
            child: Text(
              'Végösszeg: ' + ossz.toString() + 'Ft',
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          )),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: baseColor,
        title: const Text('Összegzés'),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.sList.length,
          itemBuilder: (BuildContext context, int index) {
            return ExpansionTileCard(
              initialPadding: EdgeInsets.all(12.0),
              initialElevation: MediaQuery.of(context).size.height * 0.004,
              expandedColor: Colors.amber,
              expandedTextColor: Colors.black87,
              subtitle: Text(widget.sList[index].price.toString() + ' Ft'),
              trailing: Checkbox(
                  value: widget.sList[index].checked,
                  onChanged: (bool? value) {
                    setState(() {
                      widget.sList[index].checked = value!;
                      if (widget.sList[index].checked == true) {
                        widget.sList[index].db = 1;
                        ossz = ossz + widget.sList[index].price * 1;
                        preosszeg[index] = widget.sList[index].price * 1;
                      } else if (widget.sList[index].checked == false) {
                        widget.sList[index].db = 0;
                        ossz = ossz - preosszeg[index];
                      }
                    });
                    calculate();
                  }),
              title: Text(widget.sList[index].name),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (widget.sList[index].db <= 0) {
                            } else {
                              widget.sList[index].db--;
                              ossz = ossz - widget.sList[index].price;
                            }
                            if (widget.sList[index].db == 0) {
                              widget.sList[index].checked = false;
                            }
                          });
                          calculate();
                        },
                        child: const Icon(Icons.remove)),
                    Text(
                      widget.sList[index].db.toString(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.sList[index].db++;
                            if (widget.sList[index].db > 0) {
                              widget.sList[index].checked = true;
                            }

                            ossz = ossz + widget.sList[index].price;
                            preosszeg[index] = widget.sList[index].price *
                                widget.sList[index].db;
                          });
                          calculate();
                        },
                        child: const Icon(Icons.add)),
                  ],
                )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
          backgroundColor: baseColor,
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            List<Products> passedList = [];
            for (var i = 0; i < widget.sList.length; i++) {
              if (widget.sList[i].checked == true) {
                passedList.add(widget.sList[i]);
              }
            }
            if (!passedList.isEmpty) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => Navigation(passedList))));
              widget.sList.clear();
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
          }),
    );
  }
}
