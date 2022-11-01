import 'package:flutter/material.dart';
import 'package:grocery_nav_app/screens/list.dart';
import 'package:grocery_nav_app/models/models.dart';

class Chart extends StatelessWidget {
  //Chart({super.key});

  List<Data> sList = [];
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
        foregroundColor: Colors.amber[300],
        shadowColor: Colors.blue,
        backgroundColor: Colors.blue[300],
        title: const Text('Chart'),
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
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            szamlalo++;
          }),
    );
  }
}
