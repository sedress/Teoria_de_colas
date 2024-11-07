import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true; // Variable para controlar el modo oscuro

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode; // Alternar entre modo claro y oscuro
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Colas',
      theme: _isDarkMode
          ? ThemeData.dark() // Modo oscuro
          : ThemeData.light(), // Modo claro
      home: SistemaColasScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}

class SistemaColasScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  SistemaColasScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _SistemaColasScreenState createState() => _SistemaColasScreenState();
}

class _SistemaColasScreenState extends State<SistemaColasScreen> {
  final _lambdaController = TextEditingController();
  final _muController = TextEditingController();
  final _nController = TextEditingController();
  double _espera = 0.0;
  double _utilizacion = 0.0;
  double _probabilidadVacia = 0.0;
  double _empleadosOptimos = 0.0;

  List<Map<String, dynamic>> _graphData = [];

  void _calcular() {
    if (_lambdaController.text.isEmpty || _muController.text.isEmpty || _nController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese todos los valores.')),
      );
      return;
    }

    try {
      final lambda = double.parse(_lambdaController.text);
      final mu = double.parse(_muController.text);
      final n = int.parse(_nController.text);

      final tiempoEspera = 1 / (mu - lambda);
      final utilizacion = lambda / (mu * n);
      final probabilidadVacia = 1 - utilizacion;
      final empleadosOptimos = lambda / mu;

      setState(() {
        _espera = tiempoEspera;
        _utilizacion = utilizacion;
        _probabilidadVacia = probabilidadVacia;
        _empleadosOptimos = empleadosOptimos;

        // Actualizamos los datos del gráfico
        _graphData = [
          {'name': 'Tiempo de Espera', 'value': _espera},
          {'name': 'Tasa de Utilización', 'value': _utilizacion},
          {'name': 'Probabilidad Vacía', 'value': _probabilidadVacia},
          {'name': 'Empleados Óptimos', 'value': _empleadosOptimos},
        ];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en los cálculos. Verifique los valores ingresados.')),
      );
    }
  }

  Widget _buildMetricContainer(String label, double value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  value.toStringAsFixed(2),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Colas'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => widget.toggleTheme(), // Llamamos a la función para alternar el tema
          ),
        ],
      ),
      body: SingleChildScrollView( // Hacemos la columna desplazable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _lambdaController,
                decoration: InputDecoration(labelText: 'Tasa de llegada (λ)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _muController,
                decoration: InputDecoration(labelText: 'Tasa de servicio (μ)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _nController,
                decoration: InputDecoration(labelText: 'Número de empleados (n)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcular,
                child: Text('Calcular'),
              ),
              SizedBox(height: 20),
              // Contenedor para cada resultado
              _buildMetricContainer('Tiempo de Espera', _espera),
              _buildMetricContainer('Tasa de Utilización', _utilizacion),
              _buildMetricContainer('Probabilidad de Sistema Vacío', _probabilidadVacia),
              _buildMetricContainer('Cantidad Óptima de Empleados', _empleadosOptimos),
              SizedBox(height: 20),
              // Gráfico de los resultados
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _graphData,
                    xValueMapper: (data, _) => data['name'],
                    yValueMapper: (data, _) => data['value'],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
