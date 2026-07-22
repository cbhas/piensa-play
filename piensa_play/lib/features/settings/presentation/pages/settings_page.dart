import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/accessibility/accessibility_controller.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/recovery_code_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../onboarding/data/repositories/onboarding_repository_impl.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _notifications = NotificationService();
  bool _notificationsEnabled = false;
  TimeOfDay _reminder = const TimeOfDay(hour: 18, minute: 0);
  String? _recoveryCode;
  bool _creatingCode = false;

  bool get _supportsNotifications =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = _supportsNotifications
        ? await _notifications.isEnabled()
        : false;
    final time = await _notifications.getReminderTime();
    final code = await RecoveryCodeService.instance.getRecoveryCode();
    if (!mounted) return;
    setState(() {
      _notificationsEnabled = enabled;
      _reminder = TimeOfDay(hour: time.hour, minute: time.minute);
      _recoveryCode = code;
    });
  }

  Future<void> _createRecoveryCode() async {
    setState(() => _creatingCode = true);
    final code = await RecoveryCodeService.instance.generateAndSaveCode();
    if (!mounted) return;
    setState(() {
      _creatingCode = false;
      _recoveryCode = code;
    });
  }

  Future<void> _pickReminder() async {
    final time = await showTimePicker(context: context, initialTime: _reminder);
    if (time == null) return;
    await _notifications.setReminderTime(time.hour, time.minute);
    if (mounted) setState(() => _reminder = time);
  }

  Future<void> _editName() async {
    final profile = AppDataService.instance.userProfile;
    if (profile == null) return;
    final english = context.read<AppLocaleController>().isEnglish;
    final controller = TextEditingController(text: profile.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(english ? 'Profile' : 'Perfil'),
        content: TextField(
          controller: controller,
          maxLength: 30,
          decoration: InputDecoration(labelText: english ? 'Name' : 'Nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(english ? 'Cancel' : 'Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(english ? 'Save' : 'Guardar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty) return;
    final updated = profile.copyWith(name: name);
    await OnboardingRepositoryImpl().saveUserProfile(updated);
    AppDataService.instance.updateUserProfile(updated);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<AppLocaleController>();
    final accessibility = context.watch<AccessibilityController>();
    final theme = context.watch<ThemeProvider>();
    final english = locale.isEnglish;
    final profile = AppDataService.instance.userProfile;

    return Scaffold(
      appBar: AppBar(title: Text(context.strings.t('settings'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
        children: [
          _SettingsSection(
            title: english ? 'Experience' : 'Experiencia',
            children: [
              ListTile(
                leading: const _SettingIcon(
                  Icons.language_rounded,
                  AppTheme.accentBlue,
                ),
                title: Text(context.strings.t('language')),
                subtitle: Text(locale.isEnglish ? 'English' : 'Español'),
                trailing: SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 'es', label: Text('ES')),
                    ButtonSegment(value: 'en', label: Text('EN')),
                  ],
                  selected: {locale.locale.languageCode},
                  onSelectionChanged: (value) =>
                      locale.setLocale(Locale(value.first)),
                ),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                secondary: const _SettingIcon(
                  Icons.dark_mode_outlined,
                  AppTheme.accentYellow,
                ),
                title: Text(english ? 'Dark mode' : 'Modo oscuro'),
                value: theme.isDarkMode,
                onChanged: (_) => theme.toggleTheme(),
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                secondary: const _SettingIcon(
                  Icons.text_fields_rounded,
                  AppTheme.accentGreen,
                ),
                title: Text(context.strings.t('largeText')),
                value: accessibility.largeText,
                onChanged: accessibility.setLargeText,
              ),
              const Divider(height: 1),
              SwitchListTile.adaptive(
                secondary: const _SettingIcon(
                  Icons.motion_photos_off_outlined,
                  AppTheme.accentPink,
                ),
                title: Text(context.strings.t('reducedMotion')),
                value: accessibility.reducedMotion,
                onChanged: accessibility.setReducedMotion,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SettingsSection(
            title: english ? 'Profile and reminders' : 'Perfil y recordatorios',
            children: [
              ListTile(
                leading: const _SettingIcon(
                  Icons.account_circle_outlined,
                  AppTheme.accentGreen,
                ),
                title: Text(
                  profile?.name ?? (english ? 'Explorer' : 'Explorador/a'),
                ),
                subtitle: Text(
                  english ? 'Edit display name' : 'Editar nombre visible',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _editName,
              ),
              if (_supportsNotifications) ...[
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  secondary: const _SettingIcon(
                    Icons.notifications_outlined,
                    AppTheme.accentYellow,
                  ),
                  title: Text(
                    english ? 'Daily reminder' : 'Recordatorio diario',
                  ),
                  subtitle: Text(_reminder.format(context)),
                  value: _notificationsEnabled,
                  onChanged: (value) async {
                    await _notifications.setEnabled(value);
                    if (mounted) setState(() => _notificationsEnabled = value);
                  },
                ),
                if (_notificationsEnabled)
                  ListTile(
                    leading: const SizedBox(width: 46),
                    title: Text(
                      english ? 'Reminder time' : 'Hora del recordatorio',
                    ),
                    trailing: Text(_reminder.format(context)),
                    onTap: _pickReminder,
                  ),
              ],
            ],
          ),
          const SizedBox(height: 18),
          _RecoveryCard(
            code: _recoveryCode,
            loading: _creatingCode,
            onGenerate: _createRecoveryCode,
          ),
          const SizedBox(height: 18),
          _SettingsSection(
            title: english ? 'Trust and safety' : 'Confianza y seguridad',
            children: [
              ListTile(
                leading: const _SettingIcon(
                  Icons.privacy_tip_outlined,
                  AppTheme.accentGreen,
                ),
                title: Text(
                  english ? 'Privacy for children' : 'Privacidad para menores',
                ),
                subtitle: Text(
                  english
                      ? 'What we collect and what we never collect'
                      : 'Qué guardamos y qué nunca recopilamos',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showPolicy(context, privacy: true),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const _SettingIcon(
                  Icons.gavel_outlined,
                  AppTheme.accentBlue,
                ),
                title: Text(english ? 'Responsible use' : 'Uso responsable'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showPolicy(context, privacy: false),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'PiensaPlay 0.2.0 · UNESCO Youth Hackathon 2026',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showPolicy(BuildContext context, {required bool privacy}) {
    final english = context.read<AppLocaleController>().isEnglish;
    final title = privacy
        ? (english ? 'Privacy for children' : 'Privacidad para menores')
        : (english ? 'Responsible use' : 'Uso responsable');
    final body = privacy
        ? (english
              ? 'PiensaPlay uses an anonymous account and stores only learning progress, a chosen display name, age range and avatar. It does not sell data, show ads, request contacts or record private messages. Classroom pilots must use adult consent and aggregate results.'
              : 'PiensaPlay usa una cuenta anónima y guarda únicamente progreso educativo, nombre visible elegido, rango de edad y avatar. No vende datos, muestra anuncios, solicita contactos ni registra mensajes privados. Los pilotos de aula deben tener consentimiento adulto y resultados agregados.')
        : (english
              ? 'Use verification tools without harassing people or reposting harmful material. AI output and popularity are never proof. Protect privacy, cite sources and correct respectfully.'
              : 'Usa herramientas de verificación sin acosar personas ni republicar material dañino. El contenido de IA y la popularidad nunca son pruebas. Protege la privacidad, cita fuentes y corrige con respeto.');
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: Text(english ? 'Got it' : 'Entendido'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 9),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }
}

class _SettingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _SettingIcon(this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.35 : 0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: dark ? Colors.white : AppTheme.primaryDark),
    );
  }
}

class _RecoveryCard extends StatelessWidget {
  final String? code;
  final bool loading;
  final VoidCallback onGenerate;

  const _RecoveryCard({
    required this.code,
    required this.loading,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    final english = context.watch<AppLocaleController>().isEnglish;
    return Card(
      color: AppTheme.primaryDark,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.key_rounded, color: AppTheme.accentYellow),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    english
                        ? '30-day recovery code'
                        : 'Código de recuperación por 30 días',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              english
                  ? 'Generating a new code invalidates the previous one. Keep it private.'
                  : 'Generar uno nuevo invalida el anterior. Guárdalo en privado.',
              style: const TextStyle(color: Colors.white70),
            ),
            if (code != null) ...[
              const SizedBox(height: 16),
              SelectableText(
                '${code!.substring(0, 4)}-${code!.substring(4, 8)}-${code!.substring(8, 12)}-${code!.substring(12)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                onPressed: () => Clipboard.setData(ClipboardData(text: code!)),
                icon: const Icon(Icons.copy_rounded),
                label: Text(english ? 'Copy' : 'Copiar'),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentYellow,
                foregroundColor: AppTheme.primaryDark,
              ),
              onPressed: loading ? null : onGenerate,
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      code == null
                          ? (english
                                ? 'Create recovery code'
                                : 'Crear código de recuperación')
                          : (english ? 'Replace code' : 'Reemplazar código'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
