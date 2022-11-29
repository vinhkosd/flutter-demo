import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/utils.dart';

class AppModel extends ChangeNotifier {
  bool darkTheme = false;

  Future<void> updateTheme(bool theme) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      darkTheme = theme;
      await prefs.setBool('darkTheme', theme);
      notifyListeners();
    } catch (error) {
      debugPrint('[updateTheme] error: ${error.toString()}');
    }
  }

  Future<void> init() async {
    await Utils.initConfig();

    darkTheme = Utils.isDarkTheme();
  }
}
