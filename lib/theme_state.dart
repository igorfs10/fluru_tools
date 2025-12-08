import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode?> appTheme = ValueNotifier<ThemeMode?>(null);

void toggleTheme() {
  appTheme.value = appTheme.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
}

void setTheme(ThemeMode mode) {
  appTheme.value = mode;
}
