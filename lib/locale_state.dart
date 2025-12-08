import 'package:fluru_tools/helper/preferences_service.dart';
import 'package:flutter/material.dart';

/// Notificador global do locale atual da aplicação.
/// null significa usar o locale do sistema.
final ValueNotifier<Locale?> appLocale = ValueNotifier<Locale?>(null);
final _prefsService = PreferencesService();

/// Define o locale e força rebuild do MaterialApp.
void setAppLocale(Locale locale) {
  appLocale.value = locale;
  _prefsService.saveLocale(locale); // Salvar automaticamente
}

// Carregar locale salvo ao iniciar app
Future<void> loadSavedLocale() async {
  final savedLocale = await _prefsService.getLocale();
  if (savedLocale != null) {
    appLocale.value = savedLocale;
  }
}