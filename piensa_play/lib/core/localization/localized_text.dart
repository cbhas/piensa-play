import 'package:flutter/material.dart';

/// A piece of user-facing text available in both Spanish and English.
///
/// Shared across the app's mission modules (Veracidadville, Zona Cero,
/// Ciberseguridad, and the flagship experience) so every widget resolves
/// copy the same way.
class LocalizedText {
  final String es;
  final String en;
  const LocalizedText({required this.es, required this.en});

  String resolve(Locale locale) => locale.languageCode == 'en' ? en : es;

  /// Tolerant parser for content that may come from local hardcoded data,
  /// cached SharedPreferences JSON, or a remote CMS (e.g. Firestore) that
  /// might still only provide a plain (legacy, Spanish-only) string.
  ///
  /// - A [String] value is treated as the same text for both languages.
  /// - A [Map] value is read as `{'es': ..., 'en': ...}`, falling back to
  ///   whichever key is present if the other is missing.
  /// - Anything else (null, unexpected types) resolves to empty strings.
  factory LocalizedText.fromJson(dynamic value) {
    if (value is String) {
      return LocalizedText(es: value, en: value);
    }
    if (value is Map) {
      final es = value['es']?.toString();
      final en = value['en']?.toString();
      return LocalizedText(es: es ?? en ?? '', en: en ?? es ?? '');
    }
    return const LocalizedText(es: '', en: '');
  }

  Map<String, String> toJson() => {'es': es, 'en': en};
}

extension LocalizedTextContext on BuildContext {
  Locale get appLocale => Localizations.localeOf(this);
}
