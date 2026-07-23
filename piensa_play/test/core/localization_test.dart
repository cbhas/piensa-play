import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/localization/app_locale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('persists language and resolves both catalogs', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppLocaleController();
    await controller.setLocale(const Locale('en'));

    expect(controller.isEnglish, isTrue);
    expect(const AppStrings('en').t('welcomeTitle'), 'Train your digital mind');
    expect(
      const AppStrings('es').t('welcomeTitle'),
      'Entrena tu mente digital',
    );

    final restored = AppLocaleController();
    await restored.load();
    expect(restored.locale.languageCode, 'en');
  });
}
