import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityController extends ChangeNotifier {
  static const _largeTextKey = 'accessibility_large_text';
  static const _reducedMotionKey = 'accessibility_reduced_motion';

  bool _largeText = false;
  bool _reducedMotion = false;

  bool get largeText => _largeText;
  bool get reducedMotion => _reducedMotion;
  double get textScale => _largeText ? 1.18 : 1;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _largeText = prefs.getBool(_largeTextKey) ?? false;
    _reducedMotion = prefs.getBool(_reducedMotionKey) ?? false;
    notifyListeners();
  }

  Future<void> setLargeText(bool value) async {
    _largeText = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largeTextKey, value);
    notifyListeners();
  }

  Future<void> setReducedMotion(bool value) async {
    _reducedMotion = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reducedMotionKey, value);
    notifyListeners();
  }
}
