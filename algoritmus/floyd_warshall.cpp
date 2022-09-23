// Floyd-Warshall Algorithm in C++

#include <iostream>
#include <vector>
#include <algorithm>
#include "dijkstra.hpp"

using namespace std;

// defining the number of vertices
#define nV 24

#define INF 999

void printMatrix(int matrix[][nV]);

int d_matrix[nV][nV];

// Implementing floyd warshall algorithm
void floydWarshall(int graph[][nV])
{
    int matrix[nV][nV], i, j, k;

    for (i = 0; i < nV; i++)
        for (j = 0; j < nV; j++)
            matrix[i][j] = graph[i][j];

    // Adding vertices individually
    for (k = 0; k < nV; k++)
    {
        for (i = 0; i < nV; i++)
        {
            for (j = 0; j < nV; j++)
            {
                if (matrix[i][k] + matrix[k][j] < matrix[i][j])
                    matrix[i][j] = matrix[i][k] + matrix[k][j];
            }
        }
    }
    for (i = 0; i < nV; i++)
        for (j = 0; j < nV; j++)
            d_matrix[i][j] = matrix[i][j];
    printMatrix(d_matrix);
}

void printMatrix(int matrix[][nV])
{
    for (int i = 0; i < nV; i++)
    {
        for (int j = 0; j < nV; j++)
        {
            if (matrix[i][j] == INF)
                printf("%4s", "INF");
            else
                printf("%4d", matrix[i][j]);
        }
        printf("\n");
    }
}

int main()
{
	int graph[nV][nV]={

{0, 11, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ 11,0, 1, INF, INF, INF, INF, INF, 3, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF, INF,},
{ INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, 1,0, 3, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, 3,0, 1, INF, INF, INF, INF, INF, 3, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, 3, INF, INF, INF, INF, INF, 1,0, 3, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, 3,0, 1, INF, INF, 1, INF, INF, INF, INF, INF, INF, INF, INF, 11, INF,},
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, 3, INF, INF, INF, INF, INF, 1,0, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, INF, INF, 3, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, 1, INF, INF, INF, INF, INF, INF, INF,0, 1, INF, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 3, INF, 1,0, INF, INF, 3, INF, INF, },
{ INF, 1, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF,0, 1, INF, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 1,0, 1, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 3, INF, 1,0, INF, INF, },
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, 11, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF,0, 11,}, 
{ INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, INF, 11,0,},};

    floydWarshall(graph);
    vector<int> list = {0, 1, 5, 3, 6, 8, 19, 14, 23, 17, 11};
    vector<int> order = {};
    vector<int> path = {};
    int min = INF;
    int minIndex = 0;
    int next = 0;
    int ut = 0;
    for (int i = 0; i < list.size(); i++)
    {
        for (int j = 0; j < nV; j++)
        {
            if (count(list.begin(), list.end(), j)&& d_matrix[next][j] < min&& !count(order.begin(), order.end(), j)) 
            
            {
                min = d_matrix[next][j];
                minIndex = j;
            }
        }
        ut += min;
        min = INF;
        next = minIndex;
        order.push_back(minIndex);
    }

    cout << ut << endl;
    for (int i = 0; i < order.size(); i++)
    {
        cout << order[i] << " ";
    };
    cout<<endl;
    for (int i = 1; i < order.size(); i++)
    {
        dijkstra(graph, order[i-1], order[i]);
    };
    //git teszt
}