import 'dart:async';
import 'package:arrow_path/arrow_path.dart';
import 'package:flutter/material.dart';
import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/pathFindingAlgorithm/pathFinding.dart';
import 'package:grocery_nav_app/screens/list.dart';
import 'dart:math';
import 'package:grocery_nav_app/pathFindingAlgorithm/dijkstra.dart';

const double infinity = 1.0 / 0.0;
int totalnodes = 0;
var recordDistance = infinity;
//az eddigi legjobb útvonalat tároló lista
ValueNotifier<List<int>> road = ValueNotifier<List<int>>([]);
//minden adott útvonalat tároló lista
ValueNotifier<List<int>> roadFlow = ValueNotifier<List<int>>([]);
String done = 'Az útvonal számítása folyamatban van';

List<Node> nodes = [];
List<Node> pathNodes = [];
//a termékeket tároló lista az útvonal sorrendjében
List<Products> pathOrderNodes = [];

void generate(BuildContext context) {
  double w = MediaQuery.of(context).size.width;
  double h = MediaQuery.of(context).size.height;
  //w->balról számol
  //h->h fentről számol
  nodes.add(Node(x: w * 0.37, y: h * 0.65, id: 0));

  nodes.add(Node(x: w * 0.86, y: h * 0.475, id: 1));
  nodes.add(Node(x: w * 0.86, y: h * 0.405, id: 2));
  nodes.add(Node(x: w * 0.86, y: h * 0.325, id: 3));
  nodes.add(Node(x: w * 0.86, y: h * 0.25, id: 4));

  nodes.add(Node(x: w * 0.8, y: h * 0.19, id: 5));
  nodes.add(Node(x: w * 0.65, y: h * 0.19, id: 6));
  nodes.add(Node(x: w * 0.49, y: h * 0.19, id: 7));
  nodes.add(Node(x: w * 0.33, y: h * 0.19, id: 8));
  nodes.add(Node(x: w * 0.2, y: h * 0.19, id: 9));

  nodes.add(Node(x: w * 0.08, y: h * 0.22, id: 10));
  nodes.add(Node(x: w * 0.08, y: h * 0.29, id: 11));
  nodes.add(Node(x: w * 0.08, y: h * 0.37, id: 12));
  nodes.add(Node(x: w * 0.08, y: h * 0.44, id: 13));

  nodes.add(Node(x: w * 0.7, y: h * 0.42, id: 14));
  nodes.add(Node(x: w * 0.7, y: h * 0.325, id: 15));
  nodes.add(Node(x: w * 0.595, y: h * 0.325, id: 16));
  nodes.add(Node(x: w * 0.595, y: h * 0.42, id: 17));

  nodes.add(Node(x: w * 0.41, y: h * 0.5, id: 18));
  nodes.add(Node(x: w * 0.41, y: h * 0.42, id: 19));
  nodes.add(Node(x: w * 0.41, y: h * 0.325, id: 20));
  nodes.add(Node(x: w * 0.315, y: h * 0.325, id: 21));
  nodes.add(Node(x: w * 0.315, y: h * 0.42, id: 22));
  nodes.add(Node(x: w * 0.315, y: h * 0.5, id: 23));

  nodes.add(Node(x: w * 0.12, y: h * 0.565, id: 24));
  nodes.add(Node(x: w * 0.12, y: h * 0.65, id: 25));

  //innentől a kösztes útvonal elemei vannak
  nodes.add(Node(x: w * 0.37, y: h * 0.6, id: 26));
  nodes.add(Node(x: w * 0.51, y: h * 0.6, id: 27));
  nodes.add(Node(x: w * 0.51, y: h * 0.51, id: 28));
  nodes.add(Node(x: w * 0.65, y: h * 0.51, id: 29));

  nodes.add(Node(x: w * 0.775, y: h * 0.51, id: 30));
  nodes.add(Node(x: w * 0.775, y: h * 0.44, id: 31));
  nodes.add(Node(x: w * 0.775, y: h * 0.325, id: 32));
  nodes.add(Node(x: w * 0.75, y: h * 0.24, id: 33));
  nodes.add(Node(x: w * 0.65, y: h * 0.24, id: 34));
  nodes.add(Node(x: w * 0.51, y: h * 0.24, id: 35));
  nodes.add(Node(x: w * 0.51, y: h * 0.325, id: 36));
  nodes.add(Node(x: w * 0.51, y: h * 0.42, id: 37));
  nodes.add(Node(x: w * 0.36, y: h * 0.24, id: 38));
  nodes.add(Node(x: w * 0.21, y: h * 0.24, id: 39));
  nodes.add(Node(x: w * 0.21, y: h * 0.325, id: 40));
  nodes.add(Node(x: w * 0.21, y: h * 0.42, id: 41));
  nodes.add(Node(x: w * 0.21, y: h * 0.5, id: 42));
  nodes.add(Node(x: w * 0.21, y: h * 0.6, id: 43));

  nodes.add(Node(x: w * 0.774, y: h * 0.57, id: 44));
}

class Navigation extends StatefulWidget {
  List<Products> wishList = [];

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
  //kezdő pont
  int startNode = 0;
  //végpont
  int endNode = 44;
  //populáció max mérete
  int popTotal = (99 / (1 / totalnodes) / 10).floor();
  //számláló, ami leállítja a számítást
  int counter = 0;
  //számláló max értéke
  int counterNumber = 10000;
  //populációt tároló mátrix
  List<List<int>> population = [];
  //a pontok sorrendját tároló lista
  List<int> order = [];
  //a fitness értékeket tároló lista
  List<double> fitness = [];
  //a számláló leállításához egy másolat az útvonalról
  var roadTest = road.value;
  //távolságmátrix kiszámításához egy dummy mátrix
  List<List<double>> d_matrix =
      List.generate(45, (i) => List.generate(45, (j) => 0));

  void visibility() {
    for (var i = 0; i < widget.wishList.length; i++) {
      for (var j = 0; j < nodes.length; j++) {
        if (widget.wishList[i].id == nodes[j].id) {
          nodes[j].visible = true;
          break;
        }
      }
    }
  }

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
        if (widget.wishList[i].id == nodes[j].id) {
          pathNodes.add(nodes[j]);
        }
      }
    }
    for (int i = 0; i < widget.wishList.length; i++) {
      order.add(widget.wishList[i].id);
    }

    // populáció létrehozása
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
//kezdő fitness értékek
    for (var i = 0; i < population.length; i++) {
      double d = calcDistance(pathNodes, population[i]);
      if (d < recordDistance) {
        recordDistance = d;
        road.value = population[i];
        roadFlow.value = population[i];
        print(road.value);
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
    //az iteráció lépései a megadott időközben
    calcFitness(); //fitness értékek kiszámolása
    normalizeFitness(); //fitness normalizáció
    nextGeneration(); //következő generáció a populációban
    //számláló beállítása, amennyiben talál még jobb megoldást, nullázódik
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
    super.initState();
    pathOrderNodes = [];
    nodes = [];
    pathNodes = [];
    startNode = 0;
    endNode = 44;
    population = [];
    order = [];
    fitness = [];
    counter = 0;
    roadTest = [];
    d_matrix = List.generate(45, (i) => List.generate(45, (j) => 0));
    road = ValueNotifier<List<int>>([]);
    roadFlow = ValueNotifier<List<int>>([]);
    done = 'Az útvonal számítása folyamatban van';
    recordDistance = infinity;
    setup();
    print(road.value);
    timer = Timer.periodic(const Duration(microseconds: 1), (Timer t) {
      ossz();
      if (counter >= counterNumber) {
        //végső útvonal megadása minden érintendő ponttal
        var road2 = getFinalRoute(road.value);
        road.value = List.from(road2);
        timer?.cancel();
        setState(() {
          done = 'Elkészült az útvonal!';
          roadFlow = road;
        });
        for (var i = 0; i < road.value.length; i++) {
          for (var j = 0; j < order.length; j++) {
            if (order[j] == road.value[i]) {
              for (var k = 0; k < widget.wishList.length; k++) {
                if (widget.wishList[k].id == order[j] &&
                    !pathOrderNodes.contains(widget.wishList[k])) {
                  pathOrderNodes.add(widget.wishList[k]);
                  break;
                }
              }
              break;
            }
          }
        }
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
    if (nodes.isEmpty) {
      generate(context);
      visibility();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Útvonal"),
        backgroundColor: Colors.amber,
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () {
            widget.wishList.clear();
            Navigator.pop(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const Lista();
            }));
            droad = [];
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: roadFlow,
        builder: (context, List<int> road, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.01),
                    child: Text(
                      done,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Color.fromARGB(122, 255, 193, 7),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.01)),
                ),
              ),
              Grid(
                road: road,
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.9,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  double padd = MediaQuery.of(context).size.width * 0.05;

                  return Container(
                    color: Colors.amber,
                    child: ListView.builder(
                        //physics: NeverScrollableScrollPhysics(),
                        //shrinkWrap: true,
                        controller: scrollController,
                        itemCount: pathOrderNodes.length,
                        itemBuilder: (context, index) {
                          int productPlace = pathOrderNodes[index].id;
                          String productName = pathOrderNodes[index].name;
                          int productShelf = pathOrderNodes[index].shelf;

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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        color: Color.fromARGB(122, 255, 193, 7),
                                        borderRadius:
                                            BorderRadius.circular(padd * 0.2)),
                                  ),
                                  Text("Szektor: $productPlace"),
                                  Text("Polc száma: $productShelf"),
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
                  );
                },
              ),
            ],
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
    return InteractiveViewer(
      child: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/floor.jpg"),
                    fit: BoxFit.fitWidth),
              ),
            ),
          ),
          GestureDetector(
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: ArrowPainter(
                path: road,
              ),
            ),
          ),
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
        ],
      ),
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
      width: MediaQuery.of(context).size.width * 0.06,
      height: MediaQuery.of(context).size.width * 0.06,
      decoration: BoxDecoration(
        color: visible ? Colors.amber : const Color.fromARGB(32, 0, 0, 0),
        shape: BoxShape.circle,
      ),
      child: Center(
          child: Text(
        id.toString(),
        style: TextStyle(
            color: visible ? Colors.black : const Color.fromARGB(73, 0, 0, 0)),
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
      ..strokeWidth = 5.0;
    {
      Path arrow = Path();
      arrow.moveTo(nodes[path[0]].x, nodes[path[0]].y);

      for (var i = 1; i < path.length; i++) {
        for (var j = 0; j < nodes.length; j++) {
          if (path[i] == nodes[j].id) {
            arrow.lineTo(nodes[j].x, nodes[j].y);
            if (i % 2 == 0) {
              arrow = ArrowPath.make(path: arrow);
            }
            if (i == path.length - 1) {
              arrow = ArrowPath.make(path: arrow);
            }
            break;
          }
        }
      }
      canvas.drawPath(arrow, paint..color = Colors.green);
    }
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => true;
}
