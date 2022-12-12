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
  bool checked;
  int shelf;
  Products(
      {required this.id,
      required this.price,
      required this.name,
      required this.db,
      required this.checked,
      required this.shelf});
}
