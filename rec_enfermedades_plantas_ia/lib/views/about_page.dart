import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de"),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Hacer la página desplazable
        child: Center(
          child: Padding( // Añadir relleno alrededor de todo el contenedor
            padding: const EdgeInsets.only(top: 30.0, bottom: 30.0), // Añadir espacio en la parte superior e inferior
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Hacerlo responsivo
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // cambia la posición de la sombra
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Detección de Enfermedades de Plantas",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Esta aplicación aprovecha la Inteligencia Artificial (IA) utilizando Redes Neuronales Artificiales (RNA) y Tensorflow para detectar diversas enfermedades de plantas mediante el análisis de imágenes. El sistema está entrenado para identificar enfermedades analizando imágenes de hojas de plantas y proporciona una descripción detallada de la enfermedad junto con medidas de prevención y tratamiento.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cómo funciona:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "1. Sube una imagen de la hoja de la planta.\n"
                        "2. La imagen se enviará al servidor de Python.\n"
                        "3. El modelo de IA detecta la enfermedad utilizando RNA.\n"
                        "4. Obtén una descripción de la enfermedad junto con su prevención y tratamiento.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Prevención y Tratamiento:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Para cada enfermedad detectada, la aplicación proporciona sugerencias sobre cómo prevenir la propagación de la enfermedad y ofrece recomendaciones para tratamientos adecuados.",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.green[100], // Color de fondo ligero para hacerlo más atractivo
    );
  }
}