import 'dart:async';

import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/pathFindingAlgorithm/pathFinding.dart';
import 'dart:math';

const double infinity = 1.0 / 0.0;
int totalnodes = 0;
var recordDistance = infinity;
ValueNotifier<List<int>> road = ValueNotifier<List<int>>([]);
ValueNotifier<List<int>> roadFlow = ValueNotifier<List<int>>([]);
String done = 'Navigation - Az útvonal számítása folyamatban van';

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
  //       id: i, x: random.nextDouble() * 380, y: random.nextDouble() * 690));
  // }
}

class Navigation extends StatefulWidget {
  List<int> wishList = [];
  Navigation(this.wishList) {
    wishList = wishList;
    totalnodes = wishList.length;
  }

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool showArrows = true;
  var random = Random();
  int startNode = 0;
  int endNode = 23;

  int popTotal = (99 / (1 / totalnodes) / 10).floor();
  int counter = 0;
  List<List<int>> population = [];
  List<int> order = [];
  List<double> fitness = [];
  var roadTest = road.value;
  int maxWait = (999 / (1 / totalnodes)).floor();
  //int maxWait = 1000;

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

  List<List<double>> d_matrix =
      List.generate(24, (i) => List.generate(24, (j) => 0));

  void swap(a, i, j) {
    var temp = a[i];
    a[i] = a[j];
    a[j] = temp;
  }

  void shuffle(List<int> array) {
    for (int i = 1; i < array.length - 1; i++) {
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
    totalnodes = widget.wishList.length + 2;
    visibility();
    floydWarshall(d_matrix);
    for (var i = 0; i < widget.wishList.length; i++) {
      for (var j = 0; j < nodes.length; j++) {
        if (widget.wishList[i] == nodes[j].id) {
          pathNodes.add(nodes[j]);
        }
      }
    }
    pathNodes.add(nodes[endNode]);
    for (int i = 0; i < widget.wishList.length; i++) {
      order.add(widget.wishList[i]);
    }
    // Create population
    for (int i = 0; i < popTotal; i++) {
      List<int> pop2 = [];
      population.add(order.toList());
      population[i].shuffle();
      pop2.add(startNode);
      for (int j = 0; j < population[i].length; j++) {
        pop2.add(population[i][j]);
      }
      pop2.add(endNode);
      population[i] = pop2;
    }

    for (var i = 0; i < population.length; i++) {
      double d = calcDistance(pathNodes, population[i]);
      if (d < recordDistance) {
        recordDistance = d;
        road.value = population[i];
        roadFlow.value = population[i];
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

        print(road.value);
        print(recordDistance);
      }
      fitness[i] = (1 / (d + 1));

      if (random.nextDouble() >= 0.5) {
        roadFlow.value = List.from(population[i]);
      }
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
    var r = random.nextDouble();
    while (r > 0) {
      r = r - prob[index];
      index++;
    }
    index--;
    return list[index];
  }

  void mutate(order, mutationRate) {
    for (var i = 0; i < totalnodes; i++) {
      if (random.nextDouble() < mutationRate) {
        var indexA = random.nextInt(order.length - 2) + 1.floor();
        var indexB = indexA % totalnodes;
          swap(order, indexA, indexB);
      }
    }
  }

  crossOver(List<int> orderA, List<int> orderB) {
    var start = random.nextInt(orderA.length - 2) + 1.floor();
    var end = random.nextInt(orderA.length - (start) - 1) + (start + 1).floor();
    var newOrder = orderA.sublist(start, end);

    for (var i = 0; i < orderB.length; i++) {
      var node = orderB[i];
      if (!newOrder.contains(node)) {
        newOrder.add(node);
        if (node == startNode) {
          newOrder.remove(startNode);
          newOrder[0] = startNode;
        }
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

  void ossz() {
    calcFitness();
    normalizeFitness();
    nextGeneration();
    if (roadTest == road.value) {
      counter++;
    } else {
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

    timer = Timer.periodic(const Duration(microseconds: 1), (Timer t) {
      ossz();
      if (counter >= maxWait) {
        var road2 = getFinalRoute(road.value);
        road.value = List.from(road2);
        timer?.cancel();
        setState(() {
          done = 'Navigation - Kész!';
          // print(road.value);
          roadFlow = road;
        });
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
      appBar: AppBar(title: Text(done), actions: <Widget>[
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
        valueListenable: roadFlow,
        builder: (context, List<int> road, child) {
          return InteractiveViewer(
            child: Grid(
              road: road,
            ),
          );
        },
      ),
    );
  }
}

class Grid extends StatelessWidget {
  List<int> road;
  Grid({
    super.key,
    required this.road,
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
            path: road,
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
  List<int> path;
  ArrowPainter({
    required this.path,
  });

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
      arrow.moveTo(nodes[path[0]].x, nodes[path[0]].y);

      for (var i = 1; i < path.length; i++) {
        for (var j = 0; j < nodes.length; j++) {
          if (path[i] == nodes[j].id) {
            arrow.lineTo(nodes[j].x, nodes[j].y);
            break;
          }
        }
        // for (var m = 0; m < pathNodes.length; m++) {
        //   if (road.value[i] == pathNodes[m].id) {
        //     arrow = ArrowPath.make(path: arrow);
        //   }
        // }
      }
      arrow = ArrowPath.make(path: arrow);

      canvas.drawPath(arrow, paint..color = Color.fromARGB(255, 0, 0, 0));
    }
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => true;
}
