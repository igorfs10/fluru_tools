import 'package:fluru_tools/helper/preferences_service.dart';
import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode?> appTheme = ValueNotifier<ThemeMode?>(null);
final _prefsService = PreferencesService();

void toggleTheme() {
  final newTheme = appTheme.value == ThemeMode.system
      ? ThemeMode.light
      : appTheme.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.system;
  appTheme.value = newTheme;
  _prefsService.saveTheme(newTheme); // Salvar automaticamente
}

// Carregar tema salvo ao iniciar app
Future<void> loadSavedTheme() async {
  final savedTheme = await _prefsService.getTheme();
  if (savedTheme != null) {
    appTheme.value = savedTheme;
  } else {
    // Define um padrão se não houver tema salvo
    appTheme.value = ThemeMode.system;
  }
}
