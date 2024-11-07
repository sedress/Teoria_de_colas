import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Teoría de Colas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenido a la aplicación de Teoría de Colas',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/input');
              },
              child: Text('Ingresar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
