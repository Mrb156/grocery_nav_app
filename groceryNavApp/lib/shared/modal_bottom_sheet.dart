import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';

Widget previewWidget(BuildContext context) {
  return Container(
    width: (MediaQuery.of(context).size.width),
    decoration: const BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Column(children: <Widget>[
      SizedBox(
        height: 20,
      ),
      Container(
        width: 100,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ]),
  );
}

Widget expandedWidget(List<Products> wishlist) {
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
        Expanded(
          child: ListView.builder(
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                int productPlace = wishlist[index].id;
                String productName = wishlist[index].name;
                double padd =MediaQuery.of(context).size.width*0.05;
                return Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: padd, horizontal: padd*0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Szektor: $productPlace"),
                        Text("\n\n$productName", overflow: TextOverflow.visible),
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
