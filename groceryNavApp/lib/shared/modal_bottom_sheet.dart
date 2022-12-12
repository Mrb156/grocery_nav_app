import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';

Widget previewWidget(BuildContext context) {
  double padd = MediaQuery.of(context).size.width;
  return Container(
    width: padd,
    decoration: const BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Column(children: <Widget>[
      SizedBox(
        height: padd * 0.05,
      ),
      Container(
        width: padd * 0.3,
        height: padd * 0.015,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ]),
  );
}

Widget expandedWidget(BuildContext context, List<Products> wishlist, int dist) {
  double padd = MediaQuery.of(context).size.width * 0.05;
  return Container(
    padding: EdgeInsets.all(16),
    decoration: const BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Column(
      children: <Widget>[
        const Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white),
        const SizedBox(height: 15),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              "A legrövidebb út hossza: " + dist.toString() + " m",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold),
            ),
          ),
          decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white,
              borderRadius: BorderRadius.circular(padd * 0.2)),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                int productPlace = wishlist[index].id;
                String productName = wishlist[index].name;

                return Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: padd, horizontal: padd * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              "Lépés: ${index + 1}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              color: Color.fromARGB(122, 255, 193, 7),
                              borderRadius: BorderRadius.circular(padd * 0.2)),
                        ),
                        Text("Szektor: $productPlace"),
                        Text(
                          productName,
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    ),
  );
}
