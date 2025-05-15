/// Contiene estilos de texto reutilizables para toda la aplicación,
/// definidos con la fuente 'Poppins' y diferentes pesos y tamaños.

import 'package:flutter/material.dart';
import '../styles/text_style.dart';

class AppInputStyles {
  static const InputDecoration base = InputDecoration(
    // Iconos (prefix, suffix) heredan este color
    prefixIconColor: Colors.amberAccent,
    suffixIconColor: Colors.amberAccent,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    labelStyle: AppTextStyles.textoLabelForm,
    hintStyle: AppTextStyles.textoInputForm,


  );
}