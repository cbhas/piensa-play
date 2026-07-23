// lib/features/settings/presentation/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/services/recovery_code_service.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../../home/presentation/widgets/custom_bottom_nav_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? _recoveryCode;
  bool _isLoadingCode = false;

  // Notification state
  bool _notificationsEnabled = false;
  int _reminderHour = 18;
  int _reminderMinute = 0;

  @override
  void initState() {
    super.initState();
    _loadRecoveryCode();
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final enabled = await NotificationService().isEnabled();
    final time = await NotificationService().getReminderTime();
    if (mounted) {
      setState(() {
        _notificationsEnabled = enabled;
        _reminderHour = time.hour;
        _reminderMinute = time.minute;
      });
    }
  }

  Future<void> _loadRecoveryCode() async {
    final code = await RecoveryCodeService.instance.getRecoveryCode();
    if (mounted) {
      setState(() => _recoveryCode = code);
    }
  }

  Future<void> _generateCode() async {
    setState(() => _isLoadingCode = true);
    final code = await RecoveryCodeService.instance.generateAndSaveCode();
    if (mounted) {
      setState(() {
        _recoveryCode = code;
        _isLoadingCode = false;
      });
      if (code != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Código generado! Guárdalo en un lugar seguro.'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    }
  }

  void _copyCode() {
    if (_recoveryCode != null) {
      Clipboard.setData(ClipboardData(text: _recoveryCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código copiado al portapapeles'),
          backgroundColor: AppTheme.accentBlue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
              ),
              child: const Text(
                'Ajustes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).slideFromTop(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Recovery Code Section
                    Text(
                      'Código de Recuperación',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.primaryDark,
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 50)),

                    const SizedBox(height: 12),

                    _buildRecoveryCodeCard(isDark),

                    const SizedBox(height: 24),

                    // Student Code Section
                    Text(
                      'Código de Estudiante',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.primaryDark,
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 75)),

                    const SizedBox(height: 12),

                    _buildStudentCodeCard(isDark),

                    const SizedBox(height: 32),

                    // Notifications Section
                    Text(
                      'Notificaciones',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.primaryDark,
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 100)),

                    const SizedBox(height: 12),

                    _buildNotificationsCard(isDark),

                    const SizedBox(height: 32),

                    // Appearance Section
                    Text(
                      'Apariencia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.primaryDark,
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 150)),

                    const SizedBox(height: 12),

                    // Dark Mode Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SwitchListTile(
                        title: Text(
                          'Modo Oscuro',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppTheme.textPrimaryDark
                                : AppTheme.primaryDark,
                          ),
                        ),
                        subtitle: Text(
                          isDark ? 'Activado' : 'Desactivado',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppTheme.textSecondaryDark
                                : Colors.grey.shade600,
                          ),
                        ),
                        value: isDark,
                        onChanged: (_) => themeProvider.toggleTheme(),
                        activeThumbColor: AppTheme.accentGreen,
                        secondary: Icon(
                          isDark ? Icons.dark_mode : Icons.light_mode,
                          color: isDark
                              ? AppTheme.accentYellow
                              : AppTheme.accentBlue,
                        ),
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 200)),

                    const SizedBox(height: 32),

                    // About Section
                    Text(
                      'Acerca de',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.primaryDark,
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 300)),

                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.info,
                              color: isDark
                                  ? AppTheme.accentGreen
                                  : AppTheme.primaryDark,
                            ),
                            title: Text(
                              'Versión',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.primaryDark,
                              ),
                            ),
                            trailing: Text(
                              '1.0.0',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textSecondaryDark
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.help,
                              color: isDark
                                  ? AppTheme.accentPink
                                  : AppTheme.primaryDark,
                            ),
                            title: Text(
                              'Ayuda',
                              style: TextStyle(
                                color: isDark
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.primaryDark,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // TODO: Navigate to help
                            },
                          ),
                        ],
                      ),
                    ).fadeInSlide(delay: const Duration(milliseconds: 400)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/shop');
          }
          // index == 2 is already on settings
        },
      ),
    );
  }

  Widget _buildNotificationsCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Toggle de notificaciones
          SwitchListTile(
            title: Text(
              'Recordatorio Diario',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? AppTheme.textPrimaryDark : AppTheme.primaryDark,
              ),
            ),
            subtitle: Text(
              _notificationsEnabled
                  ? 'Te recordaremos la pregunta del día'
                  : 'Desactivado',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : Colors.grey.shade600,
              ),
            ),
            value: _notificationsEnabled,
            onChanged: (value) async {
              await NotificationService().setEnabled(value);
              setState(() => _notificationsEnabled = value);
              if (mounted && value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Notificaciones activadas! 🔔'),
                    backgroundColor: AppTheme.accentGreen,
                  ),
                );
              }
            },
            activeThumbColor: AppTheme.accentGreen,
            secondary: Icon(
              _notificationsEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: _notificationsEnabled ? AppTheme.accentGreen : Colors.grey,
            ),
          ),

          // Selector de hora (solo si está habilitado)
          if (_notificationsEnabled) ...[
            Divider(
              height: 1,
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
            ListTile(
              leading: Icon(
                Icons.access_time,
                color: isDark ? AppTheme.accentYellow : AppTheme.primaryDark,
              ),
              title: Text(
                'Hora del recordatorio',
                style: TextStyle(
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.primaryDark,
                ),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.accentYellow.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_reminderHour.toString().padLeft(2, '0')}:${_reminderMinute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppTheme.accentYellow
                        : AppTheme.primaryDark,
                  ),
                ),
              ),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: _reminderHour,
                    minute: _reminderMinute,
                  ),
                );
                if (time != null) {
                  await NotificationService().setReminderTime(
                    time.hour,
                    time.minute,
                  );
                  setState(() {
                    _reminderHour = time.hour;
                    _reminderMinute = time.minute;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            // Botones de demo (solo visibles en debug; ocultos en release)
            if (kDebugMode)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await NotificationService().showDailyReminderNow();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Notificación enviada! 📚'),
                              backgroundColor: AppTheme.accentBlue,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.notifications, size: 16),
                      label: const Text(
                        'Probar\nRecordatorio',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? Colors.white
                            : AppTheme.primaryDark,
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade400,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await NotificationService().showStreakRiskNow();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('¡Alerta de racha enviada! 🔥'),
                              backgroundColor: AppTheme.accentRed,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.local_fire_department, size: 16),
                      label: const Text(
                        'Probar\nRacha',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.accentRed,
                        side: const BorderSide(color: AppTheme.accentRed),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).fadeInSlide(delay: const Duration(milliseconds: 125));
  }

  Widget _buildRecoveryCodeCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentBlue,
            AppTheme.accentBlue.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.key, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _recoveryCode != null
                      ? 'Tu código de recuperación'
                      : 'Genera tu código',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_recoveryCode != null) ...[
            // Mostrar código
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _recoveryCode!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _copyCode,
                    icon: const Icon(Icons.copy, color: Colors.white),
                    tooltip: 'Copiar código',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Guarda este código para recuperar tu cuenta en otro dispositivo',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            // Botón para generar
            Text(
              'Genera un código único para poder recuperar tu cuenta en otro dispositivo.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoadingCode ? null : _generateCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.accentBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoadingCode
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Generar Código',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    ).fadeInSlide(delay: const Duration(milliseconds: 100));
  }

  Widget _buildStudentCodeCard(bool isDark) {
    final studentCode = AppDataService.instance.userProfile?.studentCode;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentGreen,
            AppTheme.accentGreen.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGreen.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tu código de estudiante',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (studentCode != null && studentCode.isNotEmpty) ...[
            // Mostrar código
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    studentCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: studentCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Código copiado al portapapeles'),
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, color: Colors.white),
                    tooltip: 'Copiar código',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Comparte este código con tu profesor para vincular tu cuenta',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            // No hay código (no debería pasar normalmente)
            Text(
              'Código no disponible. Reinicia la app para generar uno.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    ).fadeInSlide(delay: const Duration(milliseconds: 125));
  }
}
