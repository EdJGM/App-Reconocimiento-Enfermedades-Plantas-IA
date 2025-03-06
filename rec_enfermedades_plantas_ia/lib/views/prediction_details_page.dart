import '../models/prediction.dart';
import 'package:flutter/material.dart';
import '../../database.dart';

class PredictionDetailsPage extends StatefulWidget {
  final Prediction prediction;

  const PredictionDetailsPage({Key? key, required this.prediction}) : super(key: key);

  @override
  _PredictionDetailsPageState createState() => _PredictionDetailsPageState();
}

class _PredictionDetailsPageState extends State<PredictionDetailsPage> {
  // Función para guardar la predicción
  Future<void> savePrediction(Prediction prediction) async {
    try {
      final id = await DatabaseHelper().insertPrediction(prediction);
      print('Predicción guardada con ID: $id');
    } catch (e) {
      print('Error al guardar la predicción: $e');
    }
  }

  @override
  void initState() {
    super.initState(); // ¡No olvides llamar a super.initState()!
    savePrediction(widget.prediction); // Usa widget.prediction para acceder a la predicción
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prediction.classNameEs), // Usa widget.prediction
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.prediction.examplePicture, // Usa widget.prediction
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Error al cargar la imagen'));
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
                widget.prediction.descriptionEs, // Usa widget.prediction
                style: const TextStyle(fontSize: 16, color: Colors.black)
            ),
            const SizedBox(height: 20),
            const Text(
                'Prevención:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black)
            ),
            const SizedBox(height: 8),
            Text(
                widget.prediction.preventionEs, // Usa widget.prediction
                style: const TextStyle(fontSize: 16, color: Colors.black)
            ),
            const SizedBox(height: 20),
            const Text(
                'Tratamiento:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black)
            ),
            const SizedBox(height: 8),
            Text(
                widget.prediction.treatmentEs, // Usa widget.prediction
                style: const TextStyle(fontSize: 16, color: Colors.black)
            ),
          ],
        ),
      ),
    );
  }
}