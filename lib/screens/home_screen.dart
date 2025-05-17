/// Pantalla principal que muestra el saldo actual y la lista de transacciones.
/// Permite refrescar datos, navegar al formulario para crear o editar transacciones,
/// y eliminar transacciones con confirmación.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';    // Acceso a la base de datos SQLite
import '../models/transaction.dart';    // Modelo de datos TransactionModel
import 'form_screen.dart';              // Pantalla para crear/editar transacciones
import '../styles/text_style.dart';

class HomeScreen extends StatefulWidget {
  /// Constructor de HomeScreen
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Futuro que cargará la lista de transacciones desde la base de datos
  late Future<List<TransactionModel>> _futureTxns;

  /// Futuro que cargará el balance actual (ingresos - gastos)
  late Future<double> _futureBalance;

  @override
  void initState() {
    super.initState();
    // Carga inicial de datos al crear el widget
    _loadData();
  }

  /// Método para cargar transacciones y balance desde la base de datos
  /// y notificar a Flutter para reconstruir la interfaz.
  void _loadData() {
    _futureTxns = DatabaseHelper.instance.fetchAll();
    _futureBalance = DatabaseHelper.instance.getBalance();
    setState(() {}); // Fuerza la reconstrucción para reflejar nuevos datos
  }

  @override
  Widget build(BuildContext context) {
    // Formateador de fecha día/mes/año
    final df = DateFormat('dd/MM/yy');

    return Scaffold(
      backgroundColor: const Color(0xFF3D4855), // Fondo de la aplicación
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 1,
        centerTitle: true,
        title: const Text('Control de gastos', style:AppTextStyles.tituloPantalla),
      ),
      body: Column(
        children: [
          // Sección de saldo actual con formato de moneda
          FutureBuilder<double>(
            future: _futureBalance,
            builder: (context, snapshot) {
              final bal = snapshot.data ?? 0.0;
              return Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF3D4855),
                  //border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saldo actual:', style: AppTextStyles.tituloHeader,),
                    Text(
                      NumberFormat.currency(symbol: '\$', decimalDigits: 2)
                          .format(bal),
                      style: TextStyle(
                        color: bal >= 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Lista de transacciones o mensaje de estado
          Expanded(
            child: FutureBuilder<List<TransactionModel>>(
              future: _futureTxns,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  // Indicador mientras carga
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      // Muestra error si ocurre
                      return Center(child: Text('Error: \${snapshot.error}'));
                    }
                    final txns = snapshot.data;
                    if (txns == null || txns.isEmpty) {
                      // Mensaje si no hay transacciones
                      return const Center(
                        child: Text(
                          'No se encontraron transacciones',
                          style:  AppTextStyles.textoLabelForm,
                        ),
                      );
                    }
                    // Construye la lista de transacciones
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: txns.length,
                      itemBuilder: (context, index) {
                        final txn = txns[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(left: 16, right: 0, top: 8, bottom: 8),
                            /// Editar al tocar la tarjeta: abre el formulario
                            onTap: () async {
                              final updated = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FormScreen(transaction: txn),
                                ),
                              );
                              // Si se actualizó, recarga los datos
                              if (updated == true) _loadData();
                            },
                            // Título: descripción o categoría
                            title: Text(
                              txn.description?.isNotEmpty == true
                                  ? txn.description!
                                  : txn.category,
                            ),
                            // Subtítulo: fecha y categoría
                            subtitle: Text('${df.format(txn.date)} • ${txn.category}'),
                            // Trailing: monto y botón para eliminar
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${txn.isIncome ? '+' : '-'}${txn.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: txn.isIncome ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _confirmDelete(context, txn.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),

      // Botón para agregar nueva transacción
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          if (created == true) _loadData();
        },
        child: const Icon(Icons.add),
        shape: const CircleBorder(),
        backgroundColor: Colors.amber,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Muestra un diálogo de confirmación antes de eliminar una transacción.
  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: const Text('¿Seguro que deseas eliminar este registro?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.delete(id);
              Navigator.pop(context);
              _loadData(); // Refresca la lista tras eliminar
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
