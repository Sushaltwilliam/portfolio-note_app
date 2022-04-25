import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeFrmBox(bool isDarkMode) {
    return _box.write(_key, isDarkMode);
  }

  bool _loadThemeFromBox() {
    return _box.read(_key) ?? false;
  }

  ThemeMode get theme {
    return _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  }

  void swithchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeFrmBox(!_loadThemeFromBox());
  }
}
