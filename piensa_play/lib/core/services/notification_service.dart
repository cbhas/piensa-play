import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:piensa_play/core/services/logger_service.dart';

/// Servicio para manejar notificaciones locales
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // IDs de notificaciones
  static const int _dailyReminderId = 0;
  static const int _streakRiskId = 1;

  // Keys para SharedPreferences
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyReminderHour = 'reminder_hour';
  static const String _keyReminderMinute = 'reminder_minute';

  bool _isInitialized = false;

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Inicializar timezone
    tz_data.initializeTimeZones();

    // Configurar timezone local (America/Lima para Perú)
    // Esto es necesario para que las notificaciones se programen correctamente
    tz.setLocalLocation(tz.getLocation('America/Guayaquil'));
    AppLogger.log('NOTIFICATIONS: Timezone set to America/Guayaquil');

    // Configuración para Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Configuración para iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
    AppLogger.success('NOTIFICATIONS: Initialized');

    // Programar notificaciones si están habilitadas
    if (await isEnabled()) {
      await scheduleAllNotifications();
    }
  }

  /// Callback cuando se toca una notificación
  void _onNotificationTapped(NotificationResponse response) {
    AppLogger.log('NOTIFICATIONS: Tapped notification ${response.id}');
    // Aquí se podría navegar a una pantalla específica
  }

  /// Solicita permisos de notificación
  Future<bool> requestPermissions() async {
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  /// Verifica si las notificaciones están habilitadas
  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? false;
  }

  /// Activa o desactiva las notificaciones
  Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, enabled);

    if (enabled) {
      await requestPermissions();
      await scheduleAllNotifications();
      AppLogger.success('NOTIFICATIONS: Enabled');
    } else {
      await cancelAllNotifications();
      AppLogger.log('NOTIFICATIONS: Disabled');
    }
  }

  /// Obtiene la hora del recordatorio configurada
  Future<({int hour, int minute})> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      hour: prefs.getInt(_keyReminderHour) ?? 18,
      minute: prefs.getInt(_keyReminderMinute) ?? 0,
    );
  }

  /// Configura la hora del recordatorio
  Future<void> setReminderTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyReminderHour, hour);
    await prefs.setInt(_keyReminderMinute, minute);

    // Reprogramar si están habilitadas
    if (await isEnabled()) {
      await scheduleAllNotifications();
    }
  }

  /// Programa todas las notificaciones
  Future<void> scheduleAllNotifications() async {
    await _scheduleDailyReminder();
    await _scheduleStreakRisk();
  }

  /// Programa el recordatorio diario
  Future<void> _scheduleDailyReminder() async {
    final time = await getReminderTime();

    await _notifications.zonedSchedule(
      _dailyReminderId,
      '¡Hora de aprender! 📚',
      '¡La pregunta del día te espera! No pierdas tu racha 🔥',
      _nextInstanceOfTime(time.hour, time.minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Recordatorio Diario',
          channelDescription: 'Recordatorio para responder la pregunta del día',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    AppLogger.log(
      'NOTIFICATIONS: Daily reminder scheduled for ${time.hour}:${time.minute.toString().padLeft(2, '0')}',
    );
  }

  /// Programa alerta de racha en riesgo (9 PM)
  Future<void> _scheduleStreakRisk() async {
    await _notifications.zonedSchedule(
      _streakRiskId,
      '¡Tu racha está en peligro! 🔥',
      '¡Responde la pregunta del día antes de medianoche para mantener tu racha!',
      _nextInstanceOfTime(21, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_risk',
          'Racha en Riesgo',
          channelDescription: 'Alerta cuando la racha está en peligro',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    AppLogger.log('NOTIFICATIONS: Streak risk alert scheduled for 21:00');
  }

  /// Calcula la próxima instancia de una hora específica
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Si la hora ya pasó hoy, programar para mañana
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      AppLogger.log(
        'NOTIFICATIONS: Time already passed, scheduling for tomorrow',
      );
    }

    AppLogger.log(
      'NOTIFICATIONS: Scheduled for ${scheduledDate.toString()} (now: ${now.toString()})',
    );

    return scheduledDate;
  }

  /// Cancela una notificación por ID
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancela todas las notificaciones programadas
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    AppLogger.log('NOTIFICATIONS: All notifications cancelled');
  }

  /// Cancela la alerta de racha si ya respondió hoy
  Future<void> cancelStreakRiskIfAnswered() async {
    await cancelNotification(_streakRiskId);
    AppLogger.log('NOTIFICATIONS: Streak risk cancelled (already answered)');
  }

  /// Muestra una notificación inmediata (para testing)
  Future<void> showTestNotification() async {
    await _notifications.show(
      99,
      '¡Test de Notificación! 🧪',
      'Las notificaciones están funcionando correctamente',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test',
          'Test',
          channelDescription: 'Canal de prueba',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Muestra una notificación de demo inmediata con título/body personalizables
  /// Útil para presentaciones y demos
  Future<void> showDemoNotification({
    String title = '¡La pregunta del día te espera! 📚',
    String body = 'No pierdas tu racha de aprendizaje 🔥',
  }) async {
    await _notifications.show(
      100,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'demo',
          'Demo',
          channelDescription: 'Notificaciones de demostración',
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
    AppLogger.success('NOTIFICATIONS: Demo notification shown');
  }

  /// Muestra notificación de recordatorio diario inmediatamente
  Future<void> showDailyReminderNow() async {
    await showDemoNotification(
      title: '¡Hora de aprender! 📚',
      body: '¡La pregunta del día te espera! No pierdas tu racha 🔥',
    );
  }

  /// Muestra notificación de racha en riesgo inmediatamente
  Future<void> showStreakRiskNow() async {
    await showDemoNotification(
      title: '¡Tu racha está en peligro! 🔥',
      body: '¡Responde antes de medianoche para mantener tu racha!',
    );
  }
}
