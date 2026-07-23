import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/services/recovery_code_service.dart';
import '../../../../core/theme/app_theme.dart';

class RecoverAccountPage extends StatefulWidget {
  const RecoverAccountPage({super.key});

  @override
  State<RecoverAccountPage> createState() => _RecoverAccountPageState();
}

class _RecoverAccountPageState extends State<RecoverAccountPage> {
  final _code = TextEditingController();
  Map<String, dynamic>? _account;
  String? _error;
  bool _loading = false;

  String get _normalized =>
      _code.text.toUpperCase().replaceAll(RegExp(r'[^A-Z2-9]'), '');

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final english = Localizations.localeOf(context).languageCode == 'en';
    if (_normalized.length != 16) {
      setState(() {
        _error = english
            ? 'Enter all 16 characters.'
            : 'Ingresa los 16 caracteres.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _account = null;
    });
    final account = await RecoveryCodeService.instance.findAccountByCode(
      _normalized,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _account = account;
      if (account == null) {
        _error = english
            ? 'Code not found or expired.'
            : 'Código no encontrado o vencido.';
      }
    });
  }

  Future<void> _recover() async {
    final english = Localizations.localeOf(context).languageCode == 'en';
    setState(() => _loading = true);
    final outcome = await RecoveryCodeService.instance.recoverAccount(
      _normalized,
    );
    if (!mounted) return;
    if (outcome != RecoveryOutcome.success) {
      setState(() {
        _loading = false;
        // Cada causa dice la verdad: antes cualquier fallo se anunciaba como
        // "caducado" y el usuario dejaba de intentarlo aunque su codigo
        // siguiera siendo valido.
        _error = switch (outcome) {
          RecoveryOutcome.expired =>
            english
                ? 'This code expired. Ask for a new one from the other device.'
                : 'Este código ya venció. Pide uno nuevo desde el otro dispositivo.',
          RecoveryOutcome.notFound =>
            english
                ? 'Code not found. Check the 16 characters, or it may have been used already.'
                : 'Código no encontrado. Revisa los 16 caracteres, o quizá ya se usó.',
          RecoveryOutcome.tooLarge =>
            english
                ? "There's too much progress to restore at once. Contact support."
                : 'Hay demasiado progreso para restaurarlo de una vez. Contacta con soporte.',
          _ =>
            english
                ? "Couldn't restore right now. Your code is still valid — check your connection and try again."
                : 'No se pudo restaurar ahora. Tu código sigue siendo válido: revisa tu conexión e inténtalo de nuevo.',
        };
      });
      return;
    }
    await AppDataService.instance.loadAllData();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    final profile = _account?['profile'];
    return Scaffold(
      appBar: AppBar(
        title: Text(english ? 'Recover progress' : 'Recuperar progreso'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Card(
              color: AppTheme.primaryDark,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.lock_reset_rounded,
                      color: AppTheme.accentGreen,
                      size: 48,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      english
                          ? 'One-time recovery'
                          : 'Recuperación de un solo uso',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      english
                          ? 'A code expires after 30 days and disappears once restored.'
                          : 'El código vence después de 30 días y desaparece al restaurarlo.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              maxLength: 19,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z2-9-]')),
              ],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
              decoration: InputDecoration(
                hintText: 'XXXX-XXXX-XXXX-XXXX',
                errorText: _error,
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _loading ? null : _search,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search_rounded),
              label: Text(english ? 'Find backup' : 'Buscar respaldo'),
            ),
            if (_account != null) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppTheme.accentGreen,
                        child: Icon(
                          Icons.person_rounded,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        profile is Map
                            ? (profile['name'] ??
                                      (english ? 'Explorer' : 'Explorador/a'))
                                  .toString()
                            : (english
                                  ? 'PiensaPlay backup'
                                  : 'Respaldo PiensaPlay'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 7),
                      Text(
                        english
                            ? 'Profile, missions, achievements, purchases and inventory are included.'
                            : 'Incluye perfil, misiones, logros, compras e inventario.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _loading ? null : _recover,
                          icon: const Icon(Icons.restore_rounded),
                          label: Text(
                            english ? 'Restore once' : 'Restaurar una vez',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
