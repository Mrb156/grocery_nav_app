import 'package:flutter/material.dart';

final List<IconData> icons = const [
  Icons.message,
  Icons.call,
  Icons.mail,
  Icons.notifications,
  Icons.settings,
];

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

Widget expandedWidget() {
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
              itemCount: 15,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      children: [
                        Text("Hely: $index"),
                        Text("\n\nTej meg egyéb más termék"),
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
