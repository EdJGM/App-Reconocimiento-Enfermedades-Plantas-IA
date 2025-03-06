import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prediction.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'predictions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE predictions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        className TEXT,
        confidence TEXT,
        description TEXT,
        examplePicture TEXT,
        prevention TEXT,
        treatment TEXT,
        classNameEs TEXT,
        descriptionEs TEXT,
        preventionEs TEXT,
        treatmentEs TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertPrediction(Prediction prediction) async {
    final db = await database;

    // Añadir timestamp actual
    Map<String, dynamic> predictionMap = prediction.toMap();
    predictionMap['timestamp'] = DateTime.now().toIso8601String();

    return await db.insert(
        'predictions',
        predictionMap,
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<Prediction>> getPredictions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
        'predictions',
        orderBy: 'timestamp DESC'  // Mostrar los más recientes primero
    );

    return List.generate(maps.length, (i) {
      return Prediction.fromMap(maps[i]);
    });
  }

  Future<void> deletePrediction(int id) async {
    final db = await database;
    await db.delete(
      'predictions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllPredictions() async {
    final db = await database;
    await db.delete('predictions');
  }
}