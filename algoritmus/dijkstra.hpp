using namespace std;

#include <iostream>
#include <vector>
#include <algorithm>
#include "limits.h"

int NO_PARENT = -1;
#define nV 24
#define INF 999

// Function to print shortest path
// from source to currentVertex
// using parents array
vector<int> path;
void printPath(int currentVertex, vector<int> parents)
{
	if (currentVertex == NO_PARENT)
	{
		return;
	}
	printPath(parents[currentVertex], parents);
	cout << currentVertex << " ";
	path.push_back(currentVertex);
}

void printSolution(vector<int> parents, int vertexIndex)
{	
	printPath(vertexIndex, parents);
	cout << "+ ";
}


void dijkstra(int adjacencyMatrix[nV][nV], int startVertex, int destination)
{
	int nVertices = nV;

	// shortestDistances[i] will hold the
	// shortest distance from src to i
	vector<int> shortestDistances(nVertices);

	// added[i] will true if vertex i is
	// included / in shortest path tree
	// or shortest distance from src to
	// i is finalized
	vector<bool> added(nVertices);

	// Initialize all distances as
	// INFINITE and added[] as false
	for (int vertexIndex = 0; vertexIndex < nVertices;
		 vertexIndex++)
	{
		shortestDistances[vertexIndex] = INT_MAX;
		added[vertexIndex] = false;
	}

	// Distance of source vertex from
	// itself is always 0
	shortestDistances[startVertex] = 0;

	// Parent array to store shortest
	// path tree
	vector<int> parents(nVertices);

	// The starting vertex does not
	// have a parent
	parents[startVertex] = NO_PARENT;

	// Find shortest path for all
	// vertices
	// TODO: meg kell oldani, hogy ne számolja ki az összes pontra az utat
	for (int i = 1; i < nVertices; i++)
	{

		// Pick the minimum distance vertex
		// from the set of vertices not yet
		// processed. nearestVertex is
		// always equal to startNode in
		// first iteration.
		int nearestVertex = -1;
		int shortestDistance = INT_MAX;

		for (int vertexIndex = 0; vertexIndex < nVertices;
			 vertexIndex++)
		{
			if (!added[vertexIndex] && shortestDistances[vertexIndex] < shortestDistance)
			{
				nearestVertex = vertexIndex;
				shortestDistance = shortestDistances[vertexIndex];
			}
		}

		// Mark the picked vertex as
		// processed
		added[nearestVertex] = true;

		// Update dist value of the
		// adjacent vertices of the
		// picked vertex.
		for (int vertexIndex = 0; vertexIndex < nVertices;
			 vertexIndex++)
		{
			int edgeDistance = adjacencyMatrix[nearestVertex][vertexIndex];

			if (edgeDistance > 0 && ((shortestDistance + edgeDistance) < shortestDistances[vertexIndex]))
			{
				parents[vertexIndex] = nearestVertex;
				shortestDistances[vertexIndex] = shortestDistance + edgeDistance;
			}
		}
	}
	
	printSolution(parents, destination);
	
}
