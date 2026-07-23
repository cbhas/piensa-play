import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/connectivity_service.dart';

/// Envuelve la app y muestra una píldora flotante discreta cuando no hay
/// conexión. No empuja el contenido ni bloquea toques: solo informa que se
/// está offline (el progreso se guarda y se sincroniza al reconectar).
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
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: IgnorePointer(
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    offset: isOnline ? const Offset(0, -2) : Offset.zero,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isOnline ? 0 : 1,
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8),
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
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF132757).withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.cloud_off_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}
