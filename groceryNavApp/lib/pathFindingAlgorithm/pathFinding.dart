import 'dart:io';
import 'dart:math';

import 'dijkstra.dart';

const int nV = 24;

const double INF = 1.0 / 0.0;

List<List<double>> d_matrix =
    List.generate(nV, (i) => List.generate(nV, (j) => 0));

void floydWarshall(List<List<double>> d_graph) {
  List<List<double>> matrix =
      List.generate(nV, (i) => List.generate(nV, (j) => 0));

  int i, j, k;

  for (i = 0; i < nV; i++) {
    for (j = 0; j < nV; j++) {
      matrix[i][j] = graph[i][j];
      //matrix = graph;
    }
  }

  for (k = 0; k < nV; k++) {
    for (i = 0; i < nV; i++) {
      for (j = 0; j < nV; j++) {
        if (matrix[i][k] + matrix[k][j] < matrix[i][j]) {
          matrix[i][j] = matrix[i][k] + matrix[k][j];
        }
      }
    }
  }
  for (i = 0; i < nV; i++) {
    for (j = 0; j < nV; j++) {
      d_graph[i][j] = matrix[i][j];
      // d_matrix = matrix;
    }
  }
  //printMatrix(matrix);
}

double calcDistance(order) {
  double sum = 0.0;
  for (var i = 0; i < order.length - 1; i++) {
    double d = d_matrix[order[i]][order[i + 1]];
    sum += d;
  }
  return sum;
}

void printMatrix(List<List<double>> matrix) {
  for (int i = 0; i < nV; i++) {
    for (int j = 0; j < nV; j++) {
      if (matrix[i][j] == INF)
        stdout.write("INF");
      else
        stdout.write(matrix[i][j].toString() + " ");
    }
    stdout.write("\n");
  }
}

List<List<double>> graph = [
[0, 11, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ 11,0, 1, INF, INF, INF, INF, INF, 3, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF, INF,],
[ INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, 1,0, 3, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, 3,0, 1, INF, INF, INF, INF, INF, 3, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, 3, INF, INF, INF, INF, INF, 1,0, 3, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, 3,0, 1, INF, INF, 1, INF, INF, INF, INF, INF, INF, INF, INF, 11, INF,],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, 3, INF, INF, INF, INF, INF, 1,0, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, INF, INF, 3, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF, INF, INF, INF, INF,0, 1, INF, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 3, INF, 1,0, INF, INF, 3, INF, INF, ],
[ INF, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF,0, 1, INF, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 3, INF, 1,0, INF, INF, ],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, 11, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF,0, 11,],
[ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 11,0,],];

List<int> generatePath(List<int> wishList) {
  floydWarshall(d_matrix);

  List<int> list = wishList;
  List<int> order = [];
  List<int> path = [];
  double min = INF;
  int minIndex = 0;
  int next = 0;
  double ut = 0;

  for (int i = 0; i < list.length; i++) {
    for (int j = 0; j < nV; j++) {
      if (list.contains(j) && d_matrix[next][j] < min && !order.contains(j)) {
        min = d_matrix[next][j];
        minIndex = j;
      }
    }
    ut += min;
    min = INF;
    next = minIndex;
    order.add(minIndex);
  }
  for (int i = 1; i < order.length; i++) {
    dijkstra(graph, order[i - 1], order[i]);
  }

  for (int i = 1; i < road.length; i++) {
    if (i != road.length - 1 && road[i] == road[i + 1]) {
      road.remove(road[i]);
    }
  }
  print(ut);
  print(road);
  return road;
}

List<int> getFinalRoute(order) {
  //List<int> road = [];
  for (int i = 1; i < order.length; i++) {
    dijkstra(graph, order[i - 1], order[i]);
  }

  // for (int i = 1; i < road.length; i++) {
  //   if (i != road.length - 1 && road[i] == road[i + 1]) {
  //     road.remove(road[i]);
  //   }
  // }
  return road;
}
  void swap(a, i, j) {
    var temp = a[i];
    a[i] = a[j];
    a[j] = temp;
  }

  void mutate() {
    for (var i = 0; i < 2000; i++) {
      
        var indexA = Random().nextInt(20 - 2) + 1.floor();
        var indexB = indexA % 20;
        if(indexA == 0 || indexB == 0){

        print(indexA.toString()+' '+indexB.toString());
        }
      
    }
  }

  crossOver() {
    for (var i = 0; i < 2000; i++) {
    var start = Random().nextInt(20 - 2) + 1.floor();
    var end = Random().nextInt(20 - (start) - 1) + (start + 1).floor();
    if(start == 0 || end == 0){
    print(start.toString()+' '+end.toString());}}
  }

void main() {
  crossOver();
}
