import 'dart:math';

class QueueSystem {
  final double arrivalRate; // λ - Arrival rate
  final double serviceRate; // μ - Service rate
  final int numEmployees;   // n - Number of servers

  QueueSystem({
    required this.arrivalRate,
    required this.serviceRate,
    required this.numEmployees,
  });

  double get utilizationRate => arrivalRate / (serviceRate * numEmployees);

  double get probEmpty {
    double rho = utilizationRate;
    double sum = 0.0;
    for (int k = 0; k <= numEmployees; k++) {
      sum += pow(rho, k) / factorial(k);
    }
    return 1 / sum;
  }

  double get avgWaitTime {
    double rho = utilizationRate;
    double p0 = probEmpty;
    double pN = pow(rho, numEmployees) * p0 / factorial(numEmployees);
    double Lq = pN * rho / (1 - rho);
    return Lq / arrivalRate;
  }

  int get optimalEmployees {
    int n = numEmployees;
    while (arrivalRate / (serviceRate * n) > 0.85) {
      n++;
    }
    return n;
  }

  // Helper method to calculate factorial
  int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
}