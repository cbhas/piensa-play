import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    final locale = context.watch<AppLocaleController>();
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: -80,
                right: -70,
                child: _Glow(size: 220, color: AppTheme.accentBlue),
              ),
              const Positioned(
                bottom: 40,
                left: -100,
                child: _Glow(size: 260, color: AppTheme.accentGreen),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.sizeOf(context).height -
                        MediaQuery.paddingOf(context).vertical -
                        46,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const _BrandMark(),
                          const SizedBox(width: 10),
                          Text(
                            strings.t('appName'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          _LanguageButton(locale: locale),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentYellow,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'PLAY YOUR PART · UNESCO 2026',
                            style: TextStyle(
                              color: AppTheme.tertiaryDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              width: 190,
                              height: 190,
                              decoration: BoxDecoration(
                                color: AppTheme.accentGreen,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentGreen.withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 50,
                                    spreadRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            Semantics(
                              label: 'PiensaPlay mascot',
                              image: true,
                              child: Image.asset(
                                AppConstants.mascotEmoji,
                                width: 210,
                                height: 220,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        strings.t('welcomeTitle'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(color: Colors.white, fontSize: 38),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.t('welcomeBody'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _FeaturePill(
                            icon: Icons.language_rounded,
                            label: 'ES · EN',
                          ),
                          SizedBox(width: 8),
                          _FeaturePill(
                            icon: Icons.offline_bolt_outlined,
                            label: 'OFFLINE',
                          ),
                          SizedBox(width: 8),
                          _FeaturePill(
                            icon: Icons.shield_outlined,
                            label: 'SAFE',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentYellow,
                          foregroundColor: AppTheme.tertiaryDark,
                        ),
                        onPressed: () => Navigator.of(
                          context,
                        ).pushReplacementNamed(AppRoutes.onboarding),
                        icon: const Icon(Icons.arrow_forward_rounded),
                        label: Text(strings.t('startAdventure')),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                        ),
                        onPressed: () =>
                            Navigator.of(context).pushNamed(AppRoutes.demo),
                        icon: const Icon(Icons.play_circle_outline_rounded),
                        label: Text(strings.t('tryDemo')),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.privacy_tip_outlined,
                            color: Colors.white54,
                            size: 16,
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              strings.t('privacyNote'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _LanguageButton extends StatelessWidget {
  final AppLocaleController locale;
  const _LanguageButton({required this.locale});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.strings.t('language'),
      child: InkWell(
        onTap: locale.toggle,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            children: [
              const Icon(Icons.language_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 7),
              Text(
                locale.isEnglish ? 'EN' : 'ES',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.accentGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'P',
        style: TextStyle(
          color: AppTheme.primaryDark,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentGreen, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  const _Glow({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
    );
  }
}
