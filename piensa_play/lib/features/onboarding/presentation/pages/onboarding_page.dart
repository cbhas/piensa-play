import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/save_user_profile.dart';

const _avatarNames = {
  'cocodrilo': {'es': 'Cocodrilo', 'en': 'Crocodile'},
  'jaguar': {'es': 'Jaguar', 'en': 'Jaguar'},
  'pajaro': {'es': 'Pájaro', 'en': 'Bird'},
  'tortuga': {'es': 'Tortuga', 'en': 'Turtle'},
};

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _name = TextEditingController();
  final _save = SaveUserProfile();
  int? _age;
  String _avatar = 'cocodrilo';
  bool _saving = false;

  bool get _valid => _name.text.trim().isNotEmpty && _age != null;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _name.removeListener(_refresh);
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_valid || _saving) return;
    setState(() => _saving = true);
    final profile = UserProfile(
      name: _name.text.trim(),
      age: _age!,
      avatarId: _avatar,
      studentCode: UserProfile.generateStudentCode(),
    );
    try {
      await _save.execute(profile);
      AppDataService.instance.updateUserProfile(profile);
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the profile. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          english ? 'Your explorer profile' : 'Tu perfil de explorador/a',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: AppTheme.primaryDark,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppTheme.accentGreen,
                        size: 38,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              english
                                  ? 'A private, safe adventure'
                                  : 'Una aventura privada y segura',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              english
                                  ? 'Use a nickname. We do not need your real name, email or contacts.'
                                  : 'Usa un apodo. No necesitamos tu nombre real, correo ni contactos.',
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).fadeInSlide(),
              const SizedBox(height: 22),
              Text(
                english
                    ? 'What should we call you?'
                    : '¿Cómo quieres que te llamemos?',
                style: Theme.of(context).textTheme.titleLarge,
              ).fadeInSlide(delay: 80.ms),
              const SizedBox(height: 9),
              TextField(
                controller: _name,
                maxLength: 30,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: english ? 'Nickname' : 'Apodo',
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
              ).fadeInSlide(delay: 80.ms),
              const SizedBox(height: 18),
              Text(
                english ? 'Your age range' : 'Tu edad',
                style: Theme.of(context).textTheme.titleLarge,
              ).fadeInSlide(delay: 140.ms),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [8, 9, 10, 11, 12].map((age) {
                  final selected = _age == age;
                  return ChoiceChip(
                    label: Text(english ? '$age yrs' : '$age años'),
                    selected: selected,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : AppTheme.primaryDark,
                    ),
                    selectedColor: AppTheme.primaryDark,
                    backgroundColor: AppTheme.accentGreen.withValues(
                      alpha: 0.22,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMd,
                      ),
                      side: BorderSide.none,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    onSelected: (_) => setState(() => _age = age),
                  );
                }).toList(),
              ).fadeInSlide(delay: 140.ms),
              const SizedBox(height: 26),
              Text(
                english ? 'Choose your guide' : 'Elige tu guía',
                style: Theme.of(context).textTheme.titleLarge,
              ).fadeInSlide(delay: 200.ms),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 10,
                childAspectRatio: 0.72,
                children: _avatarNames.keys.toList().asMap().entries.map((
                  entry,
                ) {
                  final index = entry.key;
                  final avatar = entry.value;
                  final selected = _avatar == avatar;
                  final name = english
                      ? _avatarNames[avatar]!['en']!
                      : _avatarNames[avatar]!['es']!;
                  return Semantics(
                    button: true,
                    selected: selected,
                    label: name,
                    child: InkWell(
                      onTap: () => setState(() => _avatar = avatar),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: AppAnimations.normal,
                            curve: Curves.easeOutBack,
                            padding: const EdgeInsets.all(6),
                            transform: Matrix4.identity()
                              ..scaleByDouble(
                                selected ? 1.06 : 1.0,
                                selected ? 1.06 : 1.0,
                                1.0,
                                1.0,
                              ),
                            transformAlignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withValues(
                                alpha: selected ? 0.32 : 0.16,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMd,
                              ),
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primaryDark
                                    : Colors.transparent,
                                width: 3,
                              ),
                              boxShadow: selected ? AppTheme.softShadow : null,
                            ),
                            child: Image.asset(
                              'assets/avatars/$avatar.png',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                              color: selected
                                  ? AppTheme.primaryDark
                                  : AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).staggeredEntry(index: index, staggerDelay: 60.ms);
                }).toList(),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _valid && !_saving ? _submit : null,
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.rocket_launch_outlined),
                label: Text(
                  english ? 'Enter Digital City' : 'Entrar a la Ciudad Digital',
                ),
              ).fadeInSlide(delay: 260.ms),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.recover),
                child: Text(
                  english
                      ? 'I have a recovery code'
                      : 'Tengo un código de recuperación',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
