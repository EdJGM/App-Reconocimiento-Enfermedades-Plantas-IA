import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Créditos"),
        centerTitle: true, // Centrar el título
      ),
      body: SingleChildScrollView( // Hacer la página desplazable
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9, // Hacerlo responsivo
            margin: const EdgeInsets.symmetric(vertical: 20), // Añadir relleno superior e inferior
            padding: const EdgeInsets.all(26.0), // Relleno del contenido
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // Cambia la posición de la sombra
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "Detección de Enfermedades de Plantas Basada en IA",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "Este es un proyecto de la asigntura Desarrollo de Aplicaciones Moviles, llamado 'Detección de Enfermedades de Plantas Basada en IA usando Aplicación Móvil'.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.justify, // Justificación del texto
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.green[100], // Color de fondo ligero para hacerlo más atractivo
    );
  }
}