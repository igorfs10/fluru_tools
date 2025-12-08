import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class PreferencesService {
  static const String _keyLanguageCode = 'language_code';
  static const String _keyCountryCode = 'country_code';
  static const String _keyTheme = 'theme_mode';

  // Salvar locale
  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguageCode, locale.languageCode);
    if (locale.countryCode != null) {
      await prefs.setString(_keyCountryCode, locale.countryCode!);
    } else {
      await prefs.remove(_keyCountryCode);
    }
  }

  // Obter locale salvo
  Future<Locale?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_keyLanguageCode);
    if (languageCode == null) return null;
    
    final countryCode = prefs.getString(_keyCountryCode);
    return Locale(languageCode, countryCode);
  }

  // Salvar tema
  Future<void> saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTheme, mode.name);
  }

  // Obter tema salvo
  Future<ThemeMode?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_keyTheme);
    if (themeName == null) return null;
    
    return ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );
  }
}