import 'package:flutter/material.dart';
import 'package:grocery_nav_app/screens/list.dart';
import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/screens/nav.dart';

class Chart extends StatelessWidget {
  //Chart({super.key});

  List<Products> sList = [];
  Chart(this.sList);

  int ossz = 0;
  void calculate() {
    for (int i = 0; i < sList.length; i++) {
      ossz = ossz + sList[i].price * sList[i].db;
    }
  }

  int szamlalo = 0;

  @override
  Widget build(BuildContext context) {
    calculate();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.amber,
        title: const Text('Chart'),
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
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              height: 500,
              padding: const EdgeInsets.all(40.0),
              margin: const EdgeInsets.all(5.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(sList[index].name),
                      trailing: Text(
                        sList[index].price.toString() +
                            'x' +
                            sList[index].db.toString(),
                        textAlign: TextAlign.start,
                      ),
                    );
                  }),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(40.0),
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Végösszeg:'),
                Text(ossz.toString() + 'Ft')
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => Navigation(sList))));
          }),
    );
  }
}
