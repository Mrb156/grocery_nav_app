import 'dart:math';

import 'package:grocery_nav_app/models/models.dart';
import 'package:grocery_nav_app/pathFindingAlgorithm/pathFinding.dart';

int popTotal = 999;
int counter = 0;
List<List<int>> population = [];
List<int> order = [];
List<double> fitness = [];

List<List<double>> d_matrix =
    List.generate(24, (i) => List.generate(24, (j) => 0));
List<int> road = [];

void setup(wishList, nodes, pathNodes, recordDistance) {
  floydWarshall(d_matrix);
  for (var i = 0; i < wishList.length; i++) {
    for (var j = 0; j < nodes.length; j++) {
      if (wishList[i] == nodes[j].id) {
        pathNodes.add(nodes[j]);
      }
    }
  }
  pathNodes.add(nodes[23]);
  for (int i = 0; i < wishList.length; i++) {
    order.add(wishList[i]);
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
      road = population[i];
    }
    fitness.add(d);
  }
}

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

void calcFitness(pathNodes, recordDistance) {
  for (var i = 0; i < population.length; i++) {
    var d = calcDistance(pathNodes, population[i]);
    if (d < recordDistance) {
      recordDistance = d;
      road = List.from(population[i]);
      print(fitness[i]);
      print(recordDistance);
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

void mutate(order, mutationRate, totalnodes) {
  for (var i = 0; i < totalnodes; i++) {
    if (Random().nextDouble() < mutationRate) {
      var indexA = Random().nextInt(order.length - 2) + 1.floor();
      var indexB = (indexA + 1) % totalnodes;
      swap(order, indexA, indexB);
    }
  }
}

crossOver(List<int> orderA, List<int> orderB) {
  var start = Random().nextInt(orderA.length - 2) + 1.floor();
  var end = Random().nextInt(orderA.length - (start) - 1) + (start + 1).floor();
  var newOrder = orderA.sublist(start, end);

  for (var i = 0; i < orderB.length; i++) {
    var node = orderB[i];
    if (!newOrder.contains(node)) {
      newOrder.add(node);
    }
  }
  return newOrder;
}

void nextGeneration(totalnodes) {
  List<List<int>> newPopulation = [];
  for (var i = 0; i < popTotal; i++) {
    var orderA = pickOne(population, fitness);
    var orderB = pickOne(population, fitness);
    var order = crossOver(orderA, orderB);
    mutate(order, 0.5, totalnodes);
    newPopulation.add(order);
  }
  population = newPopulation;
}

void calcRoad(pathNodes, recordDistance, totalnodes) {
  var roadTest = [];
    calcFitness(pathNodes, recordDistance);
    normalizeFitness();
    nextGeneration(totalnodes);
    if (roadTest == road) {
      counter++;
    } else {
      roadTest = road;
      counter = 0;
    }

}

List<int> getRoad(
    wishList, nodes, pathNodes, recordDistance, totalnodes) {
  setup(wishList, nodes, pathNodes, recordDistance);
  while(counter<=100){

  calcRoad(pathNodes, recordDistance, totalnodes);
  }

  return road;
}
