import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/queue_system.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QueueSystem queueSystem = ModalRoute.of(context)!.settings.arguments as QueueSystem;

    // Helper method to create a rectangular container for each metric
    Widget buildMetricContainer(String label, String value) {
      return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Resultados')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildMetricContainer(
              'Tasa de Utilización (ρ):',
              '${(queueSystem.utilizationRate * 100).toStringAsFixed(2)} %',
            ),
            buildMetricContainer(
              'Tiempo Promedio de Espera:',
              '${queueSystem.avgWaitTime.toStringAsFixed(2)} minutos',
            ),
            buildMetricContainer(
              'Probabilidad de Sistema Vacío (P0):',
              '${(queueSystem.probEmpty * 100).toStringAsFixed(2)} %',
            ),
            buildMetricContainer(
              'Cantidad Óptima de Empleados:',
              '${queueSystem.optimalEmployees}',
            ),
            SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, queueSystem.utilizationRate),
                      ],
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
