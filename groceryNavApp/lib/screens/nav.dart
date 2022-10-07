import 'dart:async';
import 'dart:developer';

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/pathFindingAlgorithm/ant_colony.dart';
import 'package:grocery_nav_app/pathFindingAlgorithm/dijkstra.dart';
import 'package:grocery_nav_app/pathFindingAlgorithm/pathFinding.dart';
import 'dart:math';
import 'package:darwin/darwin.dart';

int n = 12;
const double infinity = 1.0 / 0.0;
int totalnodes = n;
var recordDistance = infinity;
ValueNotifier<List<int>> road = ValueNotifier<List<int>>([]);

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
List<Node> pathNodes = [];

void generate() {
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

  // for (int i = 0; i < totalnodes; i++) {
  //   nodes.add(Node(
  //       id: i, x: Random().nextDouble() * 380, y: Random().nextDouble() * 690));
  // }
}

class Navigation extends StatefulWidget {
  List<int> wishList = [];
  Navigation(this.wishList) {
    wishList = wishList;
    n = wishList.length;
  }

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool showArrows = true;

  void visibility() {
    for (var i = 0; i < widget.wishList.length; i++) {
      for (var j = 0; j < nodes.length; j++) {
        if (widget.wishList[i] == nodes[j].id) {
          nodes[j].visible = true;
          break;
        }
      }
    }
  }

  int popTotal = 999;
  int counter = 0;
  List<List<int>> population = [];
  List<int> order = [];
  List<double> fitness = [];

  List<List<double>> d_matrix =
      List.generate(24, (i) => List.generate(24, (j) => 0));

  void swap(a, i, j) {
    var temp = a[i];
    a[i] = a[j];
    a[j] = temp;
  }

  void shuffle(List<int> array) {
    var random = Random();

    for (int i = 0; i < array.length - 1; i++) {
      var n = random.nextInt(i + 1);
      var temp = array[i];
      array[i] = array[n];
      array[n] = temp;
    }
  }

  double calcDistance(List<Node> points, order) {
    double sum = 0.0;
    for (var i = 0; i < order.length - 1; i++) {
      double d = d_matrix[order[i]][order[i + 1]];
      sum += d;
    }
    return sum;
  }

  void setup() {
    floydWarshall(d_matrix);
    for (var i = 0; i < widget.wishList.length; i++) {
      for (var j = 0; j < nodes.length; j++) {
        if (widget.wishList[i] == nodes[j].id) {
          pathNodes.add(nodes[j]);
        }
      }
    }
    pathNodes.add(nodes[23]);
    for (int i = 0; i < widget.wishList.length; i++) {
      order.add(widget.wishList[i]);
    }
    // Create population
    for (int i = 0; i < popTotal; i++) {
      List<int> pop2 = [];
      population.add(order.toList());
      population[i].shuffle();
      pop2.add(0);
      for (int j = 0; j < population[i].length; j++) {
        pop2.add(population[i][j]);
      }
      pop2.add(23);
      population[i] = pop2;
    }

    for (var i = 0; i < population.length; i++) {
      double d = calcDistance(pathNodes, population[i]);
      if (d < recordDistance) {
        recordDistance = d;
        road.value = population[i];
      }
      fitness.add(d);
    }
  }

  void calcFitness() {
    for (var i = 0; i < population.length; i++) {
      var d = calcDistance(pathNodes, population[i]);
      if (d < recordDistance) {
        recordDistance = d;
        road.value = List.from(population[i]);
        print(recordDistance);
        print(road.value);
      }
      fitness[i] = (1 / (d + 1));
    }
  }

  void normalizeFitness() {
    double sum = 0;
    for (var i = 0; i < fitness.length; i++) {
      sum += fitness[i];
    }
    for (var i = 0; i < fitness.length; i++) {
      fitness[i] = fitness[i] / sum;
    }
  }

  List<int> pickOne(list, prob) {
    int index = 0;
    var r = Random().nextDouble();
    while (r > 0) {
      r = r - prob[index];
      index++;
    }
    index--;
    return list[index];
  }

  void mutate(order, mutationRate) {
    for (var i = 0; i < totalnodes; i++) {
      if (Random().nextDouble() < mutationRate) {
        var indexA = Random().nextInt(order.length - 2) + 1.floor();
        var indexB = (indexA+1)%totalnodes;
        swap(order, indexA, indexB);
      }
    }
  }

  crossOver(List<int> orderA, List<int> orderB) {
    var start = Random().nextInt(orderA.length-2)+1.floor();
    var end = Random().nextInt(orderA.length-(start)-1) + (start + 1).floor();
    var newOrder = orderA.sublist(start, end);

    for (var i = 0; i < orderB.length; i++) {
      var node = orderB[i];
      if (!newOrder.contains(node)) {
        newOrder.add(node);
      }
    }
    return newOrder;
  }

  void nextGeneration() {
    List<List<int>> newPopulation = [];
    for (var i = 0; i < popTotal; i++) {
      var orderA = pickOne(population, fitness);
      var orderB = pickOne(population, fitness);
      var order = crossOver(orderA, orderB);
      mutate(order, 1);
      newPopulation.add(order);
    }
    population = newPopulation;
  }
  var roadTest = road.value;

  //TODO: Dijkstra, vagy valamilyen másik algoritmussal kiszámolni az útvonalat két pont között, és azt kirajzolni
  void ossz() {
    calcFitness();
    normalizeFitness();
    nextGeneration();
    if (roadTest == road.value) {
      counter++;
    }
    else{
      roadTest = road.value;
      counter = 0;
    }
  }

  Timer? timer;

  @override
  void initState() {
    generate();
    setup();
    super.initState();
    //TODO: valamilyen future-rel, és egy providerrel kell elvégezni a számításokat egy külön fájlban,
    //hogy egy progressindicator jelezze mikor készül el az útvonal
    timer =
        Timer.periodic(const Duration(microseconds: 1), (Timer t) {
          ossz();
          if (counter >= 10000) {
            timer?.cancel();
            print("end");
          }
        });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Navigation"), actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                ossz();
              },
              child: const Icon(
                Icons.search,
                size: 26.0,
              ),
            )),
      ]),
      body: ValueListenableBuilder(
        valueListenable: road,
        builder: (context, List<int> road, child) {
          return InteractiveViewer(
            child: Grid(
                //road: road,
                ),
          );
        },
      ),
    );
  }
}

class Grid extends StatelessWidget {
  //List<int> road;
  Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: List.generate(
            nodes.length,
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
          painter: ArrowPainter(
              //path: road,
              ),
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
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: visible ? Colors.amber : Color.fromARGB(32, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        id.toString(),
        style: TextStyle(
            color: visible ? Colors.black : Color.fromARGB(73, 0, 0, 0)),
      )),
    );
  }
}

class ArrowPainter extends CustomPainter {
  //List<int> path;
  // ArrowPainter({required this.path,});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3.0;
    {
      Path arrow = Path();
      arrow.moveTo(nodes[road.value[0]].x, nodes[road.value[0]].y);

      for (var i = 1; i < road.value.length; i++) {
        for (var j = 0; j < pathNodes.length; j++) {
          if (road.value[i] == pathNodes[j].id) {
            arrow.lineTo(pathNodes[j].x, pathNodes[j].y);
            break;
          }
        }
      }
      canvas.drawPath(arrow, paint..color = Color.fromARGB(255, 0, 0, 0));
    }
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => true;
}
