import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database.dart';
import '../models/modelApi.dart';
import '../models/prediction.dart';
import '../utils/constants.dart';
import 'prediction_details_page.dart';
import 'menu_drawer.dart';  // Import the new MenuDrawer widget

class PredictPage extends StatefulWidget {
  const PredictPage({Key? key}) : super(key: key);

  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  List<Prediction>? _predictions;
  bool _isLoading = false;

  void getPrediction(File image) async {
    var apiService = modelApi(baseUrl: api);
    setState(() {
      _isLoading = true; // Mostrar cargador cuando la llamada a la API comienza
      _predictions = null; // Restablecer predicciones antes de obtener nuevas
    });

    try {
      var response = await apiService.predict(image.path);
      print('API Response: $response');
      if (response.isEmpty) {
        throw Exception('Respuesta vacía de la API');
      }
      var predictions = Predictions.fromJson(response);
      setState(() {
        _predictions = [
          predictions.prediction1,
          predictions.prediction2,
          predictions.prediction3,
        ];
        _isLoading = false; // Ocultar cargador una vez que la llamada a la API se completa
      });

      // Verificar que la imagen existe antes de eliminarla
      if (await image.exists()) {
        await image.delete();
        print("Imagen eliminada exitosamente: ${image.path}");
      } else {
        print("La imagen no existe en la ruta: ${image.path}");
      }

    } catch (e) {
      print('Error al obtener la predicción: $e');
      // Mostrar mensaje de error usando Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener la predicción: $e')));
      setState(() {
        _predictions = [];
        _isLoading = false; // Ocultar cargador si hay un error
      });
    }
  }


  // Función para seleccionar imagen de la galería
  pickImageGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _predictions = null;
      });
      getPrediction(_imageFile!);
    }
  }

  // Función para capturar imagen desde la cámara
  pickImageCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _predictions = null;
      });
      getPrediction(_imageFile!);
    }
  }

  // Función para limpiar la imagen seleccionada y restablecer predicciones
  void clearImage() {
    setState(() {
      _imageFile = null;
      _predictions = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Establecer el color de fondo del AppBar a blanco
        title: const Text(
          "Detección de Enfermedades de Plantas",
          style: TextStyle(color: Colors.black), // Establecer el color del texto del título a negro
        ),
        iconTheme: IconThemeData(color: Colors.black), // Establecer el color del icono a negro
      ),
      drawer: MenuDrawer(), // Usar el MenuDrawer aquí
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // Cambia la posición de la sombra
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage('assets/upload.jpg'),
                        fit: BoxFit.cover, // Cover asegura que la imagen respete los bordes del contenedor
                        colorFilter: _imageFile == null
                            ? ColorFilter.mode(
                          Colors.grey.withOpacity(0.6),
                          BlendMode.dstATop,
                        )
                            : null,
                      ),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : null,
                  ),
                  if (_imageFile != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: clearImage, // Limpiar imagen cuando se hace clic
                      ),
                    ),
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.green.withOpacity(0.4),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              if (_predictions != null)
                for (var pred in _predictions!)
                  Card(
                    child: ListTile(
                      title: Text(pred.className),
                      subtitle: Text(
                          '${(double.parse(pred.confidence.replaceFirst('%', ''))).toStringAsFixed(2)}% de confianza'),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PredictionDetailsPage(prediction: pred),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
                onPressed: pickImageGallery,
                child: const Text("Seleccionar de la galería"),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: pickImageCamera,
                  child: const Text("Abrir cámara")),
            ],
          ),
        ),
      ),
    );
  }
}