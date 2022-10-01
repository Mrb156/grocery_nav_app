import 'dijkstra.dart';

const int nV = 24;

const int INF = 999;

  List<List<int>> d_matrix = List.generate(nV, (i) => List.generate(nV, (j) => 0));


void floydWarshall(List<List<int>> graph) {
  List<List<int>> matrix = List.generate(nV, (i) => List.generate(nV, (j) => 0));;
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
      d_matrix[i][j] = matrix[i][j];
     // d_matrix = matrix;
    }
  }
  //printMatrix(matrix);
}

void printMatrix(List<List<int>> matrix)
{
    for (int i = 0; i < nV; i++)
    {
        for (int j = 0; j < nV; j++)
        {
            if (matrix[i][j] == INF)
                print("INF");
            else
                print(matrix[i][j].toString());

        }
        print("\n");
    }
}

List<List<int>> graph = [
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
  floydWarshall(graph);

  List<int> list = wishList;
  List<int> order = [];
  List<int> path = [];
  int min = INF;
  int minIndex = 0;
  int next = 0;
  int ut = 0;

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
  return road;
}