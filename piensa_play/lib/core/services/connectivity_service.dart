import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:piensa_play/core/services/logger_service.dart';

/// Detecta el estado de conexión del dispositivo y notifica cambios.
///
/// Nota: `connectivity_plus` indica si hay una interfaz de red activa
/// (wifi/datos), no si hay acceso real a internet. Es suficiente para mostrar
/// un indicador de "sin conexión". La sincronización real de datos la maneja la
/// persistencia de Firestore, que reintenta sola al reconectar.
class ConnectivityService extends ChangeNotifier {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // Se asume online por defecto para no mostrar el banner antes de saber.
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  /// Inicializa la detección. Llamar una vez durante el arranque.
  Future<void> initialize() async {
    try {
      final current = await _connectivity.checkConnectivity();
      _update(current);
      _subscription = _connectivity.onConnectivityChanged.listen(_update);
    } catch (e) {
      AppLogger.warning('CONNECTIVITY: No se pudo inicializar: $e');
      _isOnline = true; // fallback optimista
    }
  }

  void _update(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online != _isOnline) {
      _isOnline = online;
      AppLogger.log('CONNECTIVITY: ${online ? "online" : "offline"}');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
