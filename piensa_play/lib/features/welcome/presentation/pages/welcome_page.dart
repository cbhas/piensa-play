import 'package:flutter/material.dart';
import 'package:piensa_play/core/constants/app_constants.dart';
import 'package:piensa_play/core/theme/app_theme.dart';
import 'package:piensa_play/features/welcome/domain/usecases/get_welcome_config.dart';
import 'package:piensa_play/features/welcome/domain/usecases/show_tutorial.dart';
import 'package:piensa_play/features/welcome/domain/usecases/start_adventure.dart';
import 'package:piensa_play/features/welcome/domain/entities/welcome_config.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late final GetWelcomeConfig _getWelcomeConfig;
  late final StartAdventure _startAdventure;
  late final ShowTutorial _showTutorial;
  late final WelcomeConfig _config;

  @override
  void initState() {
    super.initState();
    _getWelcomeConfig = GetWelcomeConfig();
    _startAdventure = StartAdventure();
    _showTutorial = ShowTutorial();
    _config = _getWelcomeConfig.execute();
  }

  Future<void> _onStartPressed() async {
    await _startAdventure.execute();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Comenzando aventura!')),
      );
    }
  }

  Future<void> _onTutorialPressed() async {
    await _showTutorial.execute();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mostrando tutorial')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                _buildMascotContainer(),
                const SizedBox(height: 50),
                _buildTitle(),
                const SizedBox(height: 20),
                _buildSubtitle(),
                const Spacer(),
                _buildStartButton(),
                const SizedBox(height: 16),
                _buildTutorialButton(),
                const SizedBox(height: 30),
                _buildLanguageSelector(),
                const SizedBox(height: 30),
              ],
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
                AppConstants.mascotEmoji,
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

  Widget _buildTitle() {
    return Text(
      _config.title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        height: 1.2,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      _config.subtitle,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
        height: 1.5,
      ),
    );
  }

  Widget _buildStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _onStartPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentYellow,
          foregroundColor: AppTheme.secondaryDark,
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _config.startButtonLabel,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: _onTutorialPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: AppTheme.accentGreen, width: 2),
          backgroundColor: AppTheme.accentGreen.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          _config.tutorialButtonLabel,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.language, size: 16, color: AppTheme.secondaryDark),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _config.currentLanguage,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.arrow_drop_down, color: Colors.white),
      ],
    );
  }
}