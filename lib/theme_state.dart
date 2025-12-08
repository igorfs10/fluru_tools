import 'package:fluru_tools/helper/preferences_service.dart';
import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode?> appTheme = ValueNotifier<ThemeMode?>(null);
final _prefsService = PreferencesService();

void toggleTheme() {
  final newTheme = appTheme.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
  setTheme(newTheme);
}

void setTheme(ThemeMode mode) {
  appTheme.value = mode;
  _prefsService.saveTheme(mode); // Salvar automaticamente
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