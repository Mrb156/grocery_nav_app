const int NO_PARENT = -1;
const int nV = 45;
const double INF = 1.0 / 0.0;

List<int> droad = [];

void getPath(int currentVertex, List<int> parents) {
  if (currentVertex == NO_PARENT) {
    return;
  }
  getPath(parents[currentVertex], parents);
  droad.add(currentVertex);
}

void getSolution(List<int> parents, int vertexIndex) {
  getPath(vertexIndex, parents);
}

void dijkstra(
    List<List<double>> adjacencyMatrix, int startVertex, int destination) {
  int nVertices = nV;

  List<double> shortestDistances = [];

  List<bool> added = [];

  for (int vertexIndex = 0; vertexIndex < nVertices; vertexIndex++) {
    shortestDistances.add(INF);
    added.add(false);
  }

  shortestDistances[startVertex] = 0;
  List<int> parents = [];

  for (int i = 0; i < nV; i++) {
    parents.add(i);
  }

  parents[startVertex] = NO_PARENT;

  for (var i = 1; i < nVertices; i++) {
    int nearestVertex = -1;
    double shortestDistance = 2147483647;

    for (int vertexIndex = 0; vertexIndex < nVertices; vertexIndex++) {
      if (!added[vertexIndex] &&
          shortestDistances[vertexIndex] < shortestDistance) {
        nearestVertex = vertexIndex;
        shortestDistance = shortestDistances[vertexIndex];
      }
    }

    added[nearestVertex] = true;

    for (int vertexIndex = 0; vertexIndex < nVertices; vertexIndex++) {
      double edgeDistance = adjacencyMatrix[nearestVertex][vertexIndex];

      if (edgeDistance > 0 &&
          ((shortestDistance + edgeDistance) <
              shortestDistances[vertexIndex])) {
        parents[vertexIndex] = nearestVertex;
        shortestDistances[vertexIndex] = shortestDistance + edgeDistance;
      }
    }
  }

  getSolution(parents, destination);
}
