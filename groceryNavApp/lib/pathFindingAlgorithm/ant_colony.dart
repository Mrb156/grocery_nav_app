// import 'dart:math';
// import 'dart:developer' as dev;

// const double infinity = 1.0 / 0.0;
// void swap(a, i, j) {
//   var temp = a[i];
//   a[i] = a[j];
//   a[j] = temp;
// }

// class DNA {
//   int total;
//   List order;
//   double dist = infinity;
//   double fitness = 0;
//   DNA(this.total, this.order) {
//     total = total;
//     order = order;
//     if (Random().nextDouble() < 0.5) {
//       order.shuffle();
//     } else {
//       order = [];
//       for (var i = 0; i < total; i++) {
//         order[i] = i;
//       }
//       for (var i = 0; i < 100; i++) {
//         order.shuffle();
//       }
//     }
//   }

//   double calcDistance() {
//     var sum = 0.0;
//     for (var i = 0; i < order.length - 1; i++) {
//       var cityAIndex = order[i];
//       var cityA = cities[cityAIndex];
//       var cityBIndex = order[i + 1];
//       var cityB = cities[cityBIndex];
//       var d = sqrt(pow(cityA.x - cityB.x, 2) + pow((cityA.y - cityB.y), 2));
//       sum += d;
//     }
//     dist = sum;
//     return sum;
//   }

//   double mapFitness(minD, maxD) {
//     fitness = ;
//     return fitness;
//   }

//   void normaliseFitness(total) {
//     fitness /= total;
//   }
// }

// List cities = [];
// var totalCities = 10;

// // Best path overall
// var recordDistance = infinity;
// var bestEver;

// // Population of possible orders
// int popTotal = 100;
// List<List<int>> population = [];
// List<int> order = [];
// List fitness = List.generate(population.length, (index) => 0);

// double calcDistance(points, order) {
//   var sum = 0.0;
//   for (var i = 0; i < order.length - 1; i++) {
//     var cityAIndex = order[i];
//     var cityA = points[cityAIndex];
//     var cityBIndex = order[i + 1];
//     var cityB = points[cityBIndex];
//     var d = sqrt(cityA.x * cityA.y + cityB.x * cityB.y);
//     sum += d;
//   }
//   return sum;
// }

// void setup() {
//   for (int i = 0; i < 10; i++) {
//     cities.add(Node(x: Random().nextInt(100), y: Random().nextInt(100)));
//     order.add(i);
//   }

//   // Create population
//   for (int i = 0; i < popTotal; i++) {
//     population.add(order.toList());
//     population[i].shuffle();
//   }
//   for (var i = 0; i < population.length; i++) {
//     var d = calcDistance(cities, population[i]);
//     if (d < recordDistance) {
//       recordDistance = d;
//       bestEver = population[i];
//     }
//     fitness[i] = d;
//   }
// }

// void main(List<String> args) {
//   setup();
//   print(bestEver);
// }
