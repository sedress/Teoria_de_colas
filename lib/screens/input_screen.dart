import 'package:flutter/material.dart';
import '../models/queue_system.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final arrivalRateController = TextEditingController();
  final serviceRateController = TextEditingController();
  final numEmployeesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ingreso de Datos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: arrivalRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Tasa de Llegada (λ)'),
            ),
            TextField(
              controller: serviceRateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Tasa de Servicio (μ)'),
            ),
            TextField(
              controller: numEmployeesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Número de Empleados (n)'),
            ),
            ElevatedButton(
              onPressed: () {
                // Asegúrate de convertir correctamente los valores ingresados
                final arrivalRate = double.tryParse(arrivalRateController.text) ?? 0.0;
                final serviceRate = double.tryParse(serviceRateController.text) ?? 0.0;
                final numEmployees = int.tryParse(numEmployeesController.text) ?? 1;

                Navigator.pushNamed(
                  context,
                  '/results',
                  arguments: QueueSystem(
                    arrivalRate: arrivalRate,
                    serviceRate: serviceRate,
                    numEmployees: numEmployees,
                  ),
                );
              },
              child: Text('Calcular'),
            ),
          ],
        ),
      ),
    );
  }
}
