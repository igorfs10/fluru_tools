import 'package:flutter/material.dart';

/// Notificador global do locale atual da aplicação.
/// null significa usar o locale do sistema.
final ValueNotifier<Locale?> appLocale = ValueNotifier<Locale?>(null);

/// Define o locale e força rebuild do MaterialApp.
void setAppLocale(Locale locale) {
  appLocale.value = locale;
}
