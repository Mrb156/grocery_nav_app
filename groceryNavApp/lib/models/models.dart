class Node {
  double x;
  double y;
  int id;
  bool visible;

  Node(
      {required this.x,
      required this.y,
      required this.id,
      this.visible = false});
}

class Products {
  int id;
  int price;
  String name;
  int db;
  Products(
      {required this.id,
      required this.price,
      required this.name,
      required this.db});
}

class Data {
  int price;
  int db;
  String name;

  Data({required this.db, required this.name, required this.price});
}
