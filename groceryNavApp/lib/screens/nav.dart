import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';

const double WIDTH = 2000;
const int n = 24;

List<int> wishList = [0, 1, 19, 4, 8, 13, 23];
List<int> road = [0, 1, 19, 1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 9, 22, 23];

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

List<Node> nodes = [];

void generate() {
  // for (int i = 0; i < n; i++) {
  //   nodes.add(Node(x: i + 1, y: i + 100, id: i));
  // }

  //w=411.4 h=700
  nodes.add(Node(x: 185, y: 650, id: 0));

  nodes.add(Node(x: 185, y: 500, id: 1));

  nodes.add(Node(x: 135, y: 500, id: 2));
  nodes.add(Node(x: 85, y: 500, id: 3));
  nodes.add(Node(x: 35, y: 500, id: 4));

  nodes.add(Node(x: 35, y: 400, id: 5));
  nodes.add(Node(x: 85, y: 400, id: 6));
  nodes.add(Node(x: 135, y: 400, id: 7));

  nodes.add(Node(x: 185, y: 400, id: 8));

  nodes.add(Node(x: 185, y: 300, id: 9));

  nodes.add(Node(x: 135, y: 300, id: 10));
  nodes.add(Node(x: 85, y: 300, id: 11));
  nodes.add(Node(x: 35, y: 300, id: 12));

  nodes.add(Node(x: 235, y: 300, id: 13));
  nodes.add(Node(x: 285, y: 300, id: 14));
  nodes.add(Node(x: 335, y: 300, id: 15));

  nodes.add(Node(x: 335, y: 400, id: 18));
  nodes.add(Node(x: 285, y: 400, id: 17));
  nodes.add(Node(x: 235, y: 400, id: 16));

  nodes.add(Node(x: 335, y: 500, id: 21));
  nodes.add(Node(x: 285, y: 500, id: 20));
  nodes.add(Node(x: 235, y: 500, id: 19));

  nodes.add(Node(x: 185, y: 100, id: 22));
  nodes.add(Node(x: 300, y: 100, id: 23));
}

void visibility() {
  for (var i = 0; i < wishList.length; i++) {
    for (var j = 0; j < nodes.length; j++) {
      if (wishList[i] == nodes[j].id) {
        nodes[j].visible = true;
        break;
      }
    }
  }
}

class Navigation extends StatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool showArrows = true;

  @override
  Widget build(BuildContext context) {
    generate();
    visibility();
    return Scaffold(
      appBar: AppBar(title: const Text("Navigation")),
      body: InteractiveViewer(child: const Grid()),
    );
  }
}

class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: List.generate(
            n,
            (index) {
              return Transform.translate(
                offset: Offset(nodes[index].x, nodes[index].y),
                child: Element(
                  id: nodes[index].id,
                  visible: nodes[index].visible,
                ),
              );
            },
          ),
        ),
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
          painter: ArrowPainter(),
        ),
      ],
    );
  }
}

class Element extends StatelessWidget {
  int id;
  bool visible;

  Element({super.key, required this.id, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: visible ? Colors.amber : Color.fromARGB(108, 96, 157, 255),
        shape: BoxShape.circle,
      ),
      child: Center(child: Text(id.toString())),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0;
    {
      Path path = Path();
      path.moveTo(nodes[0].x + 15, nodes[0].y + 15);
      for (int i = 1; i < road.length; i++) {
        for (int j = 0; j < n; j++) {
          if (nodes[j].id == road[i]) {
            path.lineTo(nodes[j].x + 15, nodes[j].y + 15);
            path = ArrowPath.make(path: path);
          }
        }
      }
      canvas.drawPath(path, paint..color = Color.fromARGB(255, 0, 0, 0));
    }
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => false;
}
