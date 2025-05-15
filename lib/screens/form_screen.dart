/// Pantalla de formulario para registrar o editar una transacción (gasto/ingreso).
/// Incluye validaciones, selección de fecha, categoría y tipo de transacción.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';      // Helper para operaciones en SQLite
import '../models/transaction.dart';       // Modelo de datos TransactionModel
import '../styles/text_style.dart';
import '../styles/input_styles.dart';

class FormScreen extends StatefulWidget {
  /// Si [transaction] es null: crea nueva; si no: edita existente
  final TransactionModel? transaction;
  const FormScreen({super.key, this.transaction});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Clave global para manejar el estado del formulario y sus validaciones
  final _formKey = GlobalKey<FormState>();

  // Indica si la transacción es ingreso (true) o gasto (false)
  bool _isIncome = false;

  // Controladores para los campos de monto y descripción
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  // Categoría seleccionada
  String? _category;

  // Fecha escogida para la transacción, por defecto hoy
  DateTime _pickedDate = DateTime.now();

  // Listas de categorías separadas para ingresos y gastos
  final List<String> _incomeCategories = [
    'Salario',
    'Regalo',
    'Remesa',
    'Otros',
  ];
  final List<String> _expenseCategories = [
    'Salud',
    'Ocio',
    'Casa',
    'Alimentación',
    'Educación',
    'Regalos',
    'Familia',
    'Transporte',
  ];

  /// Retorna las categorías disponibles según si es ingreso o gasto
  List<String> get _availableCategories =>
      _isIncome ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    if (t != null) {
      // Precarga valores si viene transacción para editar
      _isIncome = t.isIncome;
      _amountCtrl.text = t.amount.toString();
      _category = t.category;
      _pickedDate = t.date;
      _descCtrl.text = t.description ?? '';
    }
  }

  @override
  void dispose() {
    // Liberar recursos de los controladores
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Formateador de fechas en español: día Mes año
    final df = DateFormat('dd MMMM yyyy', 'es');

    return Scaffold(
      backgroundColor: const Color(0xFF3D4855), // Fondo principal
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Título dinámico: Nuevo ingreso/gasto o Editar
        title: Row(
          children: [
            Text(widget.transaction == null ?
            (_isIncome ? 'Nuevo ingreso' : 'Nuevo gasto') :
            'Editar registro', style: AppTextStyles.tituloPantalla,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // Asocia el formulario al GlobalKey
          child: ListView(
            children: [
              // ToggleButtons: Gasto o Ingreso con 50%/50% dinámico
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calcula aproximación de la mitad del ancho disponible para repartir 50/50,
                  // restando unos píxeles para evitar overflow por bordes
                  final dividingPadding = 8.0; // margen extra para compensar bordes
                  final halfWidth = (constraints.maxWidth - dividingPadding) / 2;
                  return ToggleButtons(
                    // Fuerza ancho fijo igual a la mitad del ancho disponible
                    constraints: BoxConstraints(
                      minWidth: halfWidth,
                      maxWidth: halfWidth,
                      minHeight: 36, // Altura mínima del botón
                    ),
                    borderRadius: BorderRadius.circular(8),
                    fillColor: Colors.amber,       // fondo al estar seleccionado
                    selectedColor: Colors.black,   // texto cuando está seleccionado
                    color: Colors.white,           // texto normal
                    borderColor: Colors.grey.shade600,
                    selectedBorderColor: Colors.amber,
                    isSelected: [_isIncome == false, _isIncome == true],
                    onPressed: (i) => setState(() {
                      _isIncome = i == 1;
                      // Resetear categoría al cambiar tipo
                      _category = null;
                    }),
                    children: [
                      Text('Gasto', style: AppTextStyles.textoFormulario),
                      Text('Ingreso', style: AppTextStyles.textoFormulario),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // Campo Monto con validación
              const Text('Monto', style: AppTextStyles.textoLabelForm,),
              const SizedBox(height: 10),
              TextFormField(
                style: AppTextStyles.textoInputForm,
                controller: _amountCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: AppInputStyles.base.copyWith(
                  labelText: 'Monto',
                  hintText: 'Ingresa el monto',
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Ingresa un monto';
                  }
                  if (double.tryParse(v) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Categoría dinámico según tipo
              const Text('Categoría', style: AppTextStyles.textoLabelForm,),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: _category,
                style: AppTextStyles.textoInputForm,
                dropdownColor: Color(0XFF283038),
                items: _availableCategories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                decoration: AppInputStyles.base,
                onChanged: (v) => setState(() => _category = v),
                validator: (v) => v == null ? 'Selecciona categoría' : null,
              ),
              const SizedBox(height: 16),

              // Selección Fecha
              const Text('Fecha', style: AppTextStyles.textoLabelForm,),
              const SizedBox(height: 10),

              OutlinedButton(
                onPressed: () async {
                  final dt = await showDatePicker(
                    context: context,
                    initialDate: _pickedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    locale: const Locale('es'),
                  );
                  if (dt != null) setState(() => _pickedDate = dt);
                },
                child: Text('${df.format(_pickedDate)}', style: AppTextStyles.textoInputForm,),
              ),
              const SizedBox(height: 16),

              // Campo Descripción opcional
              const Text('Descripción (Opcional)', style: AppTextStyles.textoLabelForm,),
              const SizedBox(height: 10),

              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: AppInputStyles.base.copyWith(
                  hintText: 'Añadir una descripción…',
                  border: OutlineInputBorder(),
                ),
                style: AppTextStyles.textoInputForm,
              ),
              const SizedBox(height: 24),

              // Botones Guardar/Actualizar y Cancelar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      // Construye el modelo con id si existe para edición
                      final txn = TransactionModel(
                        id: widget.transaction?.id,
                        isIncome: _isIncome,
                        amount: double.parse(_amountCtrl.text),
                        category: _category!,
                        date: _pickedDate,
                        description: _descCtrl.text,
                      );
                      if (widget.transaction == null) {
                        await DatabaseHelper.instance.insert(txn);
                      } else {
                        await DatabaseHelper.instance.update(txn);
                      }
                      Navigator.pop(context, true); // Indica cambios
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(widget.transaction == null ? 'Guardar' : 'Actualizar',),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Cancelar', style: AppTextStyles.textoLabelForm,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
