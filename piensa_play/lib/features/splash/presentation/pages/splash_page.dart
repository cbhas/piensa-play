import 'package:flutter/material.dart';
import 'package:piensa_play/core/routes/app_routes.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/features/splash/domain/usecases/get_splash_config.dart';
import 'package:piensa_play/features/splash/domain/entities/splash_config.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
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
    _navigateToWelcome();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  void _navigateToWelcome() {
    Future.delayed(Duration(seconds: _config.durationSeconds), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
      }
    });
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

  // Widget _buildMascotContainer() {
  //   return Container(
  //     width: 180,
  //     height: 180,
  //     decoration: BoxDecoration(
  //       color: AppTheme.mascotBackground,
  //       shape: BoxShape.circle,
  //       boxShadow: AppTheme.defaultShadow,
  //     ),
  //     child: Center(
  //       child: Text(
  //         _config.mascot,
  //         style: const TextStyle(fontSize: 100),
  //       ),
  //       //         child: Image.asset(
  //       //   _config.mascot, // o AppConstants.mascotImage

  //       // ),
  //     ),
  //   );
  // }

  Widget _buildMascotContainer() {
  return SizedBox(
    width: 180,
    height: 220, // Espacio extra arriba para las orejas
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Círculo de fondo
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
        // Mascota escalada y posicionada
        Positioned(
          bottom: 0, // Anclada al fondo
          left: 0,
          child: SizedBox(
            width: 180,
            height: 220,
            child: Transform.scale(
              scale: 1.3,
              alignment: Alignment.bottomCenter, // Escala desde abajo
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