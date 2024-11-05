import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'queue_theory_model.dart';

void main() {
  runApp(QueueApp());
}

class QueueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Teoría de Colas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PantallaCalculadoraColas(),
    );
  }
}

class PantallaCalculadoraColas extends StatefulWidget {
  @override
  _PantallaCalculadoraColasState createState() => _PantallaCalculadoraColasState();
}

class _PantallaCalculadoraColasState extends State<PantallaCalculadoraColas> {
  final _controladorLlegada = TextEditingController();
  final _controladorServicio = TextEditingController();
  final _controladorEmpleados = TextEditingController();
  QueueTheoryModel? _modeloColas;

  void _calcular() {
    setState(() {
      double tasaLlegada = double.parse(_controladorLlegada.text);
      double tasaServicio = double.parse(_controladorServicio.text);
      int numeroEmpleados = int.parse(_controladorEmpleados.text);

      _modeloColas = QueueTheoryModel(
        tasaLlegada: tasaLlegada,
        tasaServicio: tasaServicio,
        numeroEmpleados: numeroEmpleados,
      );
    });
  }

  void _mostrarGraficoTiempoEspera() {
    if (_modeloColas != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GraficoTiempoEspera(
            tiempoEsperaPromedio: _modeloColas!.tiempoEsperaPromedio,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculadora de Teoría de Colas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controladorLlegada,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Tasa de Llegada (λ)'),
            ),
            TextField(
              controller: _controladorServicio,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Tasa de Servicio (μ)'),
            ),
            TextField(
              controller: _controladorEmpleados,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Número de Empleados (n)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcular,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            if (_modeloColas != null) ...[
              TarjetaResultado(
                titulo: 'Tiempo Promedio de Espera',
                valor: '${_modeloColas!.tiempoEsperaPromedio.toStringAsFixed(2)} mins',
              ),
              TarjetaResultado(
                titulo: 'Tasa de Utilización',
                valor: '${(_modeloColas!.tasaUtilizacion * 100).toStringAsFixed(2)} %',
              ),
              TarjetaResultado(
                titulo: 'Probabilidad de Sistema Vacío',
                valor: '${(_modeloColas!.probabilidadSistemaVacio * 100).toStringAsFixed(2)} %',
              ),
              TarjetaResultado(
                titulo: 'Cantidad Óptima de Empleados',
                valor: '${_modeloColas!.cantidadOptimaEmpleados}',
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _mostrarGraficoTiempoEspera,
                child: Text('Ver Gráfico de Tiempo de Espera'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TarjetaResultado extends StatelessWidget {
  final String titulo;
  final String valor;

  TarjetaResultado({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(valor, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class GraficoTiempoEspera extends StatelessWidget {
  final double tiempoEsperaPromedio;

  GraficoTiempoEspera({required this.tiempoEsperaPromedio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gráfico de Tiempo de Espera')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 300,
            width: 350,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      10,
                          (index) => FlSpot(index.toDouble(), tiempoEsperaPromedio * (index + 1)),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue],
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toStringAsFixed(1)} mins');
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('T${value.toInt()}');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
