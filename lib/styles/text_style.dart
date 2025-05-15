/// Contiene estilos de texto reutilizables para toda la aplicación,
/// definidos con la fuente 'Poppins' y diferentes pesos y tamaños.

import 'package:flutter/material.dart';

class AppTextStyles {
  /// Título principal de pantallas
  static const TextStyle tituloPantalla = TextStyle(
      fontFamily: 'Poppins',          // Fuente principal
      fontWeight: FontWeight.w700,       // Seminegrita
      fontSize: 22,                      // Tamaño de 22 puntos
      color: Color(0xffE0DBD4)
  );

  static const TextStyle tituloHeader = TextStyle(
    fontFamily: 'Poppins',          // Fuente principal
    fontWeight: FontWeight.w500,       // Seminegrita
    fontSize: 17,
    color: Colors.white,
  );



  /// Texto descriptivo en formularios (etiquetas, subtítulos).
  static const TextStyle textoFormulario = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,       // Ligero
    fontSize: 16,                      // Tamaño de 16 puntos
  );

  static const TextStyle textoLabelForm = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,       // Ligero
    fontSize: 16,
    color: Colors.white,
  );

  static const TextStyle textoInputForm = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,       // Ligero
    fontSize: 16,
    color: Colors.white
  );

  /// Texto normal para párrafos o información general.
  static const TextStyle textoNormal = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,       // Normal
    fontSize: 16,                      // Tamaño de 16 puntos
  );

  /// Estilo de texto para botones (color de texto blanco).
  static const TextStyle textoBoton = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,       // Seminegrita
    fontSize: 16,                      // Tamaño de 16 puntos
    color: Colors.white,               // Blanco para contraste en botones
  );

  /// Estilo de texto destacado para montos positivos (color verde).
  static const TextStyle textoMonto = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,       // Negrita
    fontSize: 18,                      // Tamaño de 18 puntos
    color: Colors.green,               // Verde para indicar positivo
  );

  /// Etiquetas pequeñas (ej. fechas, categorías secundarias).
  static const TextStyle textoEtiqueta = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,       // Media
    fontSize: 14,                      // Tamaño de 14 puntos
    color: Color(0xFF3D4855),
  );

}
