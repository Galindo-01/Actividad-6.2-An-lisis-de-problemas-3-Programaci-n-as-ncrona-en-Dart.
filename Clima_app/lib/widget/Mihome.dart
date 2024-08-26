
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MiClima extends StatefulWidget {
  const MiClima({super.key});

 @override
  State<MiClima> createState() => _MiClimaState();

}

class _MiClimaState extends State<MiClima> {
  final TextEditingController _cityController = TextEditingController();
  String _temperatura = '';
  String _descripcion = '';
  String _icono = '';

  final String _apiKey = '3b5c36ae115cbd5321b6bda45d040732'; 

  Future<void> _fetchWeather() async {
    final city = _cityController.text;
    final url = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _temperatura = '${data['main']['temp']} °C';
        _descripcion = data['weather'][0]['description'];
        _icono = 'http://openweathermap.org/img/wn/${data['weather'][0]['icon']}.png';
      });
    } else {
      setState(() {
        _temperatura = 'Error';
        _descripcion = '';
        _icono = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Clima'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Ciudad:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingresar la ciudad',
              ),
            ),
            SizedBox(height: 8),
            
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text("Actualizar"),
            ),
            SizedBox(height: 8),

            if (_icono.isNotEmpty)
              Row(
                children: [
                  Image.network(_icono, width: 50, height: 50),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Temperatura: $_temperatura',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Descripcion: $_descripcion',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}