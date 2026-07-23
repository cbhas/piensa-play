import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/connectivity_service.dart';

/// Envuelve la app y muestra una píldora flotante discreta cuando no hay
/// conexión. No empuja el contenido ni bloquea toques: solo informa que se
/// está offline (el progreso se guarda y se sincroniza al reconectar).
///
/// Se ancla ABAJO-centro, no arriba: casi todas las pantallas tienen su título
/// centrado en la parte superior (el nombre en el inicio, "¡Pregunta del día!",
/// el nombre de la categoría…) y una píldora arriba-centro los tapaba. Abajo
/// va elevada sobre la barra de navegación para no solaparla.
class OfflineBanner extends StatelessWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ConnectivityService.instance,
      builder: (context, _) {
        final isOnline = ConnectivityService.instance.isOnline;
        return Stack(
          children: [
            child,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: IgnorePointer(
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    // Fuera de pantalla (hacia abajo) cuando hay conexión.
                    offset: isOnline ? const Offset(0, 2) : Offset.zero,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isOnline ? 0 : 1,
                      // Margen inferior amplio: por encima de la barra de
                      // navegación del inicio y dejando aire para que los
                      // SnackBar (que aparecen abajo) no queden tapados.
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 132),
                        child: Center(child: _OfflinePill()),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfflinePill extends StatelessWidget {
  const _OfflinePill();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF132757).withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Sin conexión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
