/// Modelo de datos que representa una transacción financiera (gasto o ingreso).
/// Incluye campos para identificación, tipo, monto, categoría, fecha y descripción opcional.
class TransactionModel {
  /// Identificador único de la transacción en la base de datos.
  /// Puede ser null antes de insertar el registro por primera vez.
  final int? id;

  /// Indica si la transacción es un ingreso (true) o un gasto (false).
  final bool isIncome;

  /// Monto numérico de la transacción.
  final double amount;

  /// Categoría de la transacción (por ejemplo, "Alimentación" o "Salud").
  final String category;

  /// Fecha de la transacción como DateTime.
  final DateTime date;

  /// Descripción opcional para detalles adicionales.
  final String? description;

  /// Constructor principal.
  ///
  /// [id] es opcional y suele ser generado automáticamente por SQLite.
  /// Los demás campos son requeridos para crear una transacción válida.
  TransactionModel({
    this.id,
    required this.isIncome,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  /// Convierte este modelo en un mapa clave-valor para guardar en SQLite.
  ///
  /// - 'id': puede ser null para nuevas inserciones.
  /// - 'isIncome': se guarda como 1 (true) o 0 (false).
  /// - 'date': se almacena en formato ISO 8601 como String.
  Map<String, dynamic> toMap() => {
    'id': id,
    'isIncome': isIncome ? 1 : 0,
    'amount': amount,
    'category': category,
    'date': date.toIso8601String(),
    'description': description,
  };

  /// Crea una instancia de [TransactionModel] a partir de un mapa de datos.
  ///
  /// Se espera que [m] provenga de una consulta SQL (Map<String, dynamic>).
  factory TransactionModel.fromMap(Map<String, dynamic> m) => TransactionModel(
    id: m['id'] as int?,
    isIncome: m['isIncome'] == 1,
    amount: m['amount'] as double,
    category: m['category'] as String,
    date: DateTime.parse(m['date'] as String),
    description: m['description'] as String?,
  );
}
