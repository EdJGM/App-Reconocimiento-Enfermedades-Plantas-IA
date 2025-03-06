import 'package:flutter/material.dart';
import '../database.dart';
import '../models/prediction.dart';
import 'prediction_details_page.dart';

class PredictionHistoryPage extends StatefulWidget {
  @override
  _PredictionHistoryPageState createState() => _PredictionHistoryPageState();
}

class _PredictionHistoryPageState extends State<PredictionHistoryPage> {
  late Future<List<Prediction>> _predictionsFuture;

  @override
  void initState() {
    super.initState();
    _refreshPredictions();
  }

  void _refreshPredictions() {
    setState(() {
      _predictionsFuture = DatabaseHelper().getPredictions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Análisis'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () => _showDeleteConfirmDialog(),
            tooltip: 'Borrar historial',
          ),
        ],
      ),
      body: FutureBuilder<List<Prediction>>(
        future: _predictionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No hay predicciones guardadas',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las predicciones que realices se guardarán automáticamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final prediction = snapshot.data![index];
                return Dismissible(
                  key: Key(index.toString()), // Usar un ID único si está disponible
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Eliminar elemento
                    DatabaseHelper().deletePrediction(index); // Usar ID real si está disponible
                    setState(() {
                      snapshot.data!.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Predicción eliminada'))
                    );
                  },
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar'),
                          content: Text('¿Estás seguro de que quieres eliminar esta predicción?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Eliminar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(prediction.examplePicture),
                        onBackgroundImageError: (_, __) {
                          // Manejar error de carga de imagen
                        },
                        child: prediction.examplePicture == 'N/A'
                            ? Icon(Icons.image_not_supported)
                            : null,
                      ),
                      title: Text(
                        prediction.classNameEs,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        prediction.descriptionEs.length > 60
                            ? prediction.descriptionEs.substring(0, 60) + '...'
                            : prediction.descriptionEs,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PredictionDetailsPage(prediction: prediction),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Borrar historial'),
          content: Text('¿Estás seguro de que quieres borrar todo el historial de predicciones?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                DatabaseHelper().deleteAllPredictions();
                _refreshPredictions();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Historial borrado'))
                );
              },
              child: Text('Borrar'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }
}