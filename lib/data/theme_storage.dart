import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  static const String _keyAppBarColor = 'app_bar_color';

  static const int defaultColorValue = 0xFF374151;

  static Future<Color> loadAppBarColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_keyAppBarColor) ?? defaultColorValue;
    return Color(colorValue);
  }

  static Future<void> saveAppBarColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAppBarColor, color.toARGB32());
  }
}
