import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/connectivity_service.dart';

/// Envuelve la app y muestra un banner en la parte inferior cuando no hay
/// conexión, comunicando al usuario que su progreso se guardará localmente y se
/// sincronizará al reconectar (offline-first).
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
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                offset: isOnline ? const Offset(0, 1) : Offset.zero,
                child: const _OfflineBar(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfflineBar extends StatelessWidget {
  const _OfflineBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          color: const Color(0xFF132757),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Sin conexión — tu progreso se guardará y se sincronizará al reconectar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
