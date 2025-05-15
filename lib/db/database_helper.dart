/// Helper para gestionar la base de datos SQLite de transacciones.
/// Implementa singleton para compartir una única instancia de Database.

import 'package:sqflite/sqflite.dart';            // Plugin SQLite para Flutter
import 'package:path_provider/path_provider.dart';  // Proporciona rutas del sistema de archivos
import 'package:path/path.dart';                   // Utilities para manipular rutas
import '../models/transaction.dart';                // Modelo de datos TransactionModel
import 'dart:io';                                   // Para trabajar con directorios de archivos

class DatabaseHelper {
  /// Instancia singleton de DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._init();

  /// Variable privada que almacenará la referencia a la base de datos SQLite
  static Database? _db;

  /// Constructor privado para evitar instancias externas
  DatabaseHelper._init();

  /// Getter para obtener (o inicializar) la base de datos
  Future<Database> get database async {
    // Si ya está inicializada, la retornamos directamente
    if (_db != null) return _db!;
    // Si no, inicializamos con el nombre del archivo
    _db = await _initDB('transactions.db');
    return _db!;
  }

  /// Inicializa la base de datos abriendo (o creando) el archivo en disco
  /// [fileName] Nombre del archivo de la base de datos
  Future<Database> _initDB(String fileName) async {
    // Obtiene el directorio de documentos de la aplicación
    final dir = await getApplicationDocumentsDirectory();
    // Construye la ruta completa al archivo de la base de datos
    final path = join(dir.path, fileName);
    // Abre la base de datos, definiendo la versión y el callback onCreate
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Crea las tablas necesarias cuando la base de datos no existía
  /// [db] Instancia de la base de datos recién abierta
  /// [version] Versión actual (1 en este caso)
  Future _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      isIncome INTEGER NOT NULL,
      amount REAL NOT NULL,
      category TEXT NOT NULL,
      date TEXT NOT NULL,
      description TEXT
    )''';
    // Ejecuta la sentencia SQL para crear la tabla
    await db.execute(sql);
  }

  /// Inserta una nueva transacción en la tabla 'transactions'.
  /// Retorna el id generado para el nuevo registro.
  Future<int> insert(TransactionModel t) async {
    final db = await database;
    return await db.insert('transactions', t.toMap());
  }

  /// Recupera todas las transacciones ordenadas por fecha descendente.
  /// Retorna una lista de TransactionModel.
  Future<List<TransactionModel>> fetchAll() async {
    final db = await database;
    // Consulta todas las filas, ordenando por columna 'date' de forma descendente
    final maps = await db.query('transactions', orderBy: 'date DESC');
    // Convierte cada mapa en una instancia de TransactionModel
    return maps.map((m) => TransactionModel.fromMap(m)).toList();
  }

  /// Calcula el balance total: suma de ingresos menos suma de gastos.
  /// Retorna el valor numérico del balance.
  Future<double> getBalance() async {
    // Carga todas las transacciones
    final list = await fetchAll();
    // Usa fold para acumular el balance: ingresos positivos y gastos negativos
    return list.fold<double>(
      0.0,
          (sum, t) => sum + (t.isIncome ? t.amount : -t.amount),
    );
  }

  /// Actualiza un registro existente en la tabla 'transactions'.
  /// Devuelve el número de filas afectadas (1 si todo salió bien).
  Future<int> update(TransactionModel t) async {
    final db = await database;
    return await db.update(
      'transactions',       // tabla a actualizar
      t.toMap(),            // datos actualizados
      where: 'id = ?',      // condición WHERE
      whereArgs: [t.id],     // argumentos de la condición
    );
  }

  /// Elimina un registro de la tabla 'transactions' por su [id].
  /// Devuelve el número de filas eliminadas.
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',       // tabla de la que eliminar
      where: 'id = ?',      // condición WHERE
      whereArgs: [id],       // argumentos de la condición
    );
  }

  /// Cierra la conexión a la base de datos (libera recursos).
  Future close() async {
    final db = await database;
    await db.close();
  }
}
