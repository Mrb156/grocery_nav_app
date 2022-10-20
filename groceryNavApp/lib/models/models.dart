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

  Products({required this.id, required this.price, required this.name});
}
