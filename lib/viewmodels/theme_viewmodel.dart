import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/theme_storage.dart';

part 'theme_viewmodel.g.dart';

@riverpod
class ThemeViewModel extends _$ThemeViewModel {
  @override
  Color build() {
    _loadSavedColor();
    return const Color(ThemeStorage.defaultColorValue);
  }

  Future<void> _loadSavedColor() async {
    final saved = await ThemeStorage.loadAppBarColor();
    state = saved;
  }

  Future<void> setAppBarColor(Color color) async {
    state = color;
    await ThemeStorage.saveAppBarColor(color);
  }
}
