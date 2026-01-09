import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piensa_play/core/routes/app_routes.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/core/services/app_data_service.dart';
import 'package:piensa_play/features/splash/domain/usecases/get_splash_config.dart';
import 'package:piensa_play/features/splash/domain/entities/splash_config.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

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
  String _loadingMessage = 'Cargando...';

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
    final dataLoadFuture = _loadAppData();

    // Wait for minimum splash duration
    await Future.delayed(Duration(seconds: _config.durationSeconds));

    // Wait for data to finish loading (if not already done)
    await dataLoadFuture;

    if (!mounted) return;

    // Check if user has completed onboarding
    final prefs = await SharedPreferences.getInstance();
    final hasProfile = prefs.containsKey('user_profile');

    print('🔵 SPLASH: Checking profile... hasProfile: $hasProfile');

    if (hasProfile) {
      // User has completed onboarding, go directly to home
      print('🟢 SPLASH: Profile found, navigating to home');
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      // New user, show welcome/onboarding
      print('🟡 SPLASH: No profile, navigating to welcome');
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    }
  }

  Future<void> _loadAppData() async {
    try {
      setState(() => _loadingMessage = 'Cargando misiones...');
      await AppDataService.instance.loadAllData();
      setState(() => _loadingMessage = '¡Listo!');
    } catch (e) {
      print('⚠️ SPLASH: Error loading data: $e');
    }
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
