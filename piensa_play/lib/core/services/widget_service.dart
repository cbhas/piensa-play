import 'package:home_widget/home_widget.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import 'package:piensa_play/core/services/daily_question_service.dart';

/// Servicio para manejar el widget de pantalla de inicio
class WidgetService {
  static final WidgetService _instance = WidgetService._internal();
  factory WidgetService() => _instance;
  WidgetService._internal();

  static const String _widgetName = 'PiensaPlayWidget';
  static const String _appGroupId = 'group.com.example.piensa_play';

  /// Inicializa el servicio de widgets
  Future<void> initialize() async {
    await HomeWidget.setAppGroupId(_appGroupId);
    await updateWidget();
    AppLogger.success('WIDGET: Initialized');
  }

  /// Actualiza el widget con el estado actual de la racha
  Future<void> updateWidget() async {
    try {
      // Verificar si respondió hoy
      final hasAnsweredToday = await DailyQuestionService().hasAnsweredToday();
      final streak = AppDataService.instance.dailyStreak;
      final hour = DateTime.now().hour;

      // Determinar estado
      String state;
      if (hasAnsweredToday) {
        state = 'completed'; // Vizcacha con fuego 🔥
      } else if (hour >= 20) {
        state = 'at_risk'; // Vizcacha preocupada 😰
      } else {
        state = 'pending'; // Vizcacha normal
      }

      // Guardar datos para el widget nativo
      await HomeWidget.saveWidgetData<String>('state', state);
      await HomeWidget.saveWidgetData<int>('streak', streak);

      // Actualizar widget
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
      );

      AppLogger.log('WIDGET: Updated - state: $state, streak: $streak');
    } catch (e) {
      AppLogger.error('WIDGET: Error updating: $e');
    }
  }

  /// Actualiza el widget a estado completado (después de responder)
  Future<void> markAsCompleted(int streak) async {
    try {
      await HomeWidget.saveWidgetData<String>('state', 'completed');
      await HomeWidget.saveWidgetData<int>('streak', streak);
      await HomeWidget.updateWidget(
        name: _widgetName,
        androidName: _widgetName,
      );
      AppLogger.success('WIDGET: Marked as completed with streak $streak');
    } catch (e) {
      AppLogger.error('WIDGET: Error marking completed: $e');
    }
  }

  /// Fuerza actualización del widget (útil para testing)
  Future<void> forceUpdate() async {
    await updateWidget();
  }
}
