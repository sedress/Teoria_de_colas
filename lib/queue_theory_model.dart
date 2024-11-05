// queue_theory_model.dart

class QueueTheoryModel {
  final double tasaLlegada; // Tasa de llegada (λ)
  final double tasaServicio; // Tasa de servicio (μ)
  final int numeroEmpleados; // Número de empleados (n)

  QueueTheoryModel({
    required this.tasaLlegada,
    required this.tasaServicio,
    required this.numeroEmpleados,
  });

  // Cálculo de la utilización de empleados (ρ)
  double get tasaUtilizacion => tasaLlegada / (numeroEmpleados * tasaServicio);

  // Tiempo promedio de espera en la fila (Wq)
  double get tiempoEsperaPromedio {
    double rho = tasaUtilizacion;
    return (rho / (1 - rho)) / tasaLlegada;
  }

  // Probabilidad de que el sistema esté vacío (P0)
  double get probabilidadSistemaVacio => 1 - tasaUtilizacion;

  // Cantidad óptima de empleados recomendada para minimizar el tiempo de espera
  int get cantidadOptimaEmpleados {
    int empleadosOptimos = numeroEmpleados;
    double minTiempoEspera = tiempoEsperaPromedio;

    // Buscamos el número mínimo de empleados que minimiza el tiempo de espera
    for (int i = 1; i <= 10; i++) {
      double utilizacion = tasaLlegada / (i * tasaServicio);
      double tiempoEspera = (utilizacion / (1 - utilizacion)) / tasaLlegada;
      if (tiempoEspera < minTiempoEspera) {
        minTiempoEspera = tiempoEspera;
        empleadosOptimos = i;
      }
    }
    return empleadosOptimos;
  }
}
