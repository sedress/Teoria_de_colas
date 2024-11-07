import 'dart:math';

class QueueSystem {
  final double arrivalRate; // λ - Tasa de llegada
  final double serviceRate; // μ - Tasa de servicio
  final int numEmployees;   // n - Número de servidores

  QueueSystem({
    required this.arrivalRate,
    required this.serviceRate,
    required this.numEmployees,
  });

  double get utilizationRate => arrivalRate / (serviceRate * numEmployees);

  double get probEmpty {
    double rho = utilizationRate;
    double sum = 0.0;
    for (int k = 0; k < numEmployees; k++) {
      sum += pow(arrivalRate / serviceRate, k) / factorial(k);
    }
    double lastTerm = (pow(arrivalRate / serviceRate, numEmployees) /
        (factorial(numEmployees) * (1 - rho)));
    double p0 = 1 / (sum + lastTerm);
    return p0;
  }

  double get avgWaitTime {
    double rho = utilizationRate;
    double p0 = probEmpty;
    double lq = (p0 * pow(arrivalRate / serviceRate, numEmployees) * rho) /
        (factorial(numEmployees) * pow(1 - rho, 2));
    return lq / arrivalRate;
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
