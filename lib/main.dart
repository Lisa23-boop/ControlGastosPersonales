// Punto de entrada de la aplicación Control de Gastos Personales con Flutter.
/// Aquí se configura el soporte de internacionalización y se levanta el widget raíz.

import 'package:flutter/material.dart';
// Importa las localizaciones de Material, widgets y Cupertino (iOS)
import 'package:flutter_localizations/flutter_localizations.dart';
// Importa los datos de formato de fecha para diferentes locales (Intl)
import 'package:intl/date_symbol_data_local.dart';
// Importa la pantalla de carga inicial (loading)
import 'screens/loading.dart';

/// Función principal "main" marcada como async para await.
/// Inicializa Flutter y los datos de fecha antes de ejecutar la app.
Future<void> main() async {
  // Asegura que el binding de Flutter esté listo antes de cualquier operación asíncrona
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la información de formato de fechas para el locale 'es' (español)
  await initializeDateFormatting('es', null);

  // Ejecuta el widget raíz de la aplicación
  runApp(const ControlGastosPersonales());
}

/// Widget raíz de la aplicación.
/// Define el título, tema, localización y la pantalla inicial (LoadingScreen).
class ControlGastosPersonales extends StatelessWidget {
  const ControlGastosPersonales({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Elimina la etiqueta DEBUG del banner
      debugShowCheckedModeBanner: false,
      // Título de la aplicación (usado por el sistema operativo)
      title: 'Control de Gastos Personales',
      // Define el tema principal: colores y tipografía
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),

      // ↓ Configuración de localización para soportar múltiples idiomas ↓
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,  // Traducciones de Material widgets
        GlobalWidgetsLocalizations.delegate,   // Traducciones de widgets básicos
        GlobalCupertinoLocalizations.delegate, // Traducciones de widgets iOS
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
      // Fuerza el idioma español independientemente del idioma del dispositivo
      locale: const Locale('es', ''),
      // ↑ Fin de la configuración de localización ↑

      // Pantalla inicial mostrada al arrancar la app
      home: const LoadingScreen(),
    );
  }
}
