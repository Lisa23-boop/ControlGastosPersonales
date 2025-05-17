/// Pantalla de carga inicial que muestra un logo y un indicador de progreso,
/// luego navega automáticamente a la pantalla principal "HomeScreen".

import 'package:control_gastos_personales/styles/text_style.dart'; // Estilos de texto personalizados
import 'package:flutter/material.dart';
import 'dart:async'; // Para usar Future y Duration
import 'home_screen.dart'; // Importa la pantalla de inicio a la que se navega posteriormente

/// Widget Stateful para manejar la temporización y la navegación
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

/// Estado asociado a LoadingScreen
class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Programar un retardo de 3 segundos antes de cambiar de pantalla
    Future.delayed(const Duration(seconds: 3), () {
      // Reemplaza la ruta actual por HomeScreen (evita poder "volver atrás" a loading)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Estructura visual de la pantalla de carga
    return Scaffold(
      backgroundColor: const Color(0xFF3D4855), // Color de fondo principal
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
          children: [
            // Logo: imagen de la abeja
            Image.asset('assets/images/gallina.png', height: 150),
            const SizedBox(height: 20), // Separación vertical
            // Título de la app, multilineal y centrado
            const Text(
              'Control de Gastos Personales',
              textAlign: TextAlign.center,
              style: AppTextStyles.tituloPantalla,
            ),
            // Subtítulo o crédito del grupo
            const Text(
              'Por Grupo 57',
              style: AppTextStyles.textoLabelForm,
            ),
            const SizedBox(height: 30), // Espacio antes del indicador
            // Indicador circular de progreso
            const CircularProgressIndicator(
              color: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
