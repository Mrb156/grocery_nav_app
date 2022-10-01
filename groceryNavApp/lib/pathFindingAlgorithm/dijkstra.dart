const int NO_PARENT = -1;
const int nV = 24;
const int INF = 999;

List<int> road = [];

void printPath(int currentVertex, List<int> parents) {
  if (currentVertex == NO_PARENT) {
    return;
  }
  printPath(parents[currentVertex], parents);
  road.add(currentVertex);
}

void printSolution(List<int> parents, int vertexIndex) {
  printPath(vertexIndex, parents);
}

void dijkstra(
    List<List<int>> adjacencyMatrix, int startVertex, int destination) {
  int nVertices = nV;

  List<int> shortestDistances = [];

  List<bool> added = [];

  for (int vertexIndex = 0; vertexIndex < nVertices; vertexIndex++) {
    shortestDistances.add(INF);
    added.add(false);
  }

  shortestDistances[startVertex] = 0;

  //var parents = List.filled(nV, 0, growable: true);
  List<int> parents = [];

  for (int i = 0; i < nV; i++) {
    parents.add(i);
  }

  // ignore: prefer_void_to_null
  parents[startVertex] = NO_PARENT;

  for (var i = 1; i < nVertices; i++) {
    int nearestVertex = -1;
    int shortestDistance = 2147483647;

    for (int vertexIndex = 0; vertexIndex < nVertices; vertexIndex++) {
      if (!added[vertexIndex] &&
          shortestDistances[vertexIndex] < shortestDistance) {
        nearestVertex = vertexIndex;
        shortestDistance = shortestDistances[vertexIndex];
      }
    }

    added[nearestVertex] = true;

    for (int vertexIndex = 0; vertexIndex < nVertices; vertexIndex++) {
      int edgeDistance = adjacencyMatrix[nearestVertex][vertexIndex];

      if (edgeDistance > 0 &&
          ((shortestDistance + edgeDistance) <
              shortestDistances[vertexIndex])) {
        parents[vertexIndex] = nearestVertex;
        shortestDistances[vertexIndex] = shortestDistance + edgeDistance;
      }
    }
  }

  printSolution(parents, destination);
}
