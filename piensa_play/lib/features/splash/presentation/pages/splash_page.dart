import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/routes/app_routes.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import 'package:piensa_play/core/services/widget_service.dart';
import 'package:piensa_play/features/splash/domain/usecases/get_splash_config.dart';
import 'package:piensa_play/features/splash/domain/entities/splash_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late final GetSplashConfig _getSplashConfig;
  late final SplashConfig _config;

  @override
  void initState() {
    super.initState();
    _getSplashConfig = GetSplashConfig();
    _config = _getSplashConfig.execute();
    _initializeAnimations();
    _loadDataAndNavigate();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  Future<void> _loadDataAndNavigate() async {
    // Start loading data immediately
    final dataLoaded = await _loadAppData().timeout(
      const Duration(seconds: 2),
      onTimeout: () => false,
    );

    // Wait for minimum splash duration
    await Future.delayed(Duration(seconds: _config.durationSeconds));

    if (!mounted) return;

    // Si la carga falló y no hay datos cacheados, mostrar diálogo de reintento
    if (!dataLoaded) {
      AppLogger.warning('SPLASH: continuing with offline-ready content');
    }

    // Check if user has completed onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasProfile = prefs.containsKey('user_profile');

    if (!mounted) return;

    AppLogger.log('SPLASH: Checking profile... hasProfile: $hasProfile');

    if (hasProfile) {
      // User has completed onboarding, go directly to home
      AppLogger.success('SPLASH: Profile found, navigating to home');
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      // New user, show welcome/onboarding
      AppLogger.log('SPLASH: No profile, navigating to welcome');
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    }
  }

  /// Returns true if data loaded successfully, false otherwise
  Future<bool> _loadAppData() async {
    try {
      await AppDataService.instance.loadAllData();

      // Actualizar widget con datos cargados
      if (AppDataService.instance.isLoaded && !kIsWeb) {
        await WidgetService().updateWidget();
      }

      return AppDataService.instance.isLoaded;
    } catch (e) {
      AppLogger.warning('SPLASH: Error loading data: $e');
      return false;
    }
  }

  // Legacy retry dialog retained for future manual refresh entry points.
  // ignore: unused_element
  Future<bool> _showRetryDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Error de conexión'),
            content: const Text(
              'No se pudieron cargar los datos. '
              'Verifica tu conexión a internet e intenta de nuevo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Continuar sin datos'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMascotContainer(),
                  const SizedBox(height: 30),
                  _buildAppName(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMascotContainer() {
    return SizedBox(
      width: 180,
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: AppTheme.mascotBackground,
                shape: BoxShape.circle,
                boxShadow: AppTheme.defaultShadow,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: 180,
              height: 220,
              child: Transform.scale(
                scale: 1.3,
                alignment: Alignment.bottomCenter,
                child: Image.asset(
                  _config.mascot,
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      _config.appName,
      style: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
    );
  }
}
