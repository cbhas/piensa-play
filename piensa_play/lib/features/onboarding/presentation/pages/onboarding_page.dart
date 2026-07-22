import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/app_data_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/save_user_profile.dart';

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
              ),
              const SizedBox(height: 22),
              Text(
                english
                    ? 'What should we call you?'
                    : '¿Cómo quieres que te llamemos?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 9),
              TextField(
                controller: _name,
                maxLength: 30,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: english ? 'Nickname' : 'Apodo',
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                english ? 'Your age range' : 'Tu edad',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 9),
              DropdownButtonFormField<int>(
                initialValue: _age,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.cake_outlined),
                ),
                hint: Text(english ? 'Choose an age' : 'Elige una edad'),
                items: [8, 9, 10, 11, 12]
                    .map(
                      (age) => DropdownMenuItem(
                        value: age,
                        child: Text(english ? '$age years old' : '$age años'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _age = value),
              ),
              const SizedBox(height: 24),
              Text(
                english ? 'Choose your guide' : 'Elige tu guía',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: ['cocodrilo', 'jaguar', 'pajaro', 'tortuga']
                    .map(
                      (avatar) => Semantics(
                        button: true,
                        selected: _avatar == avatar,
                        label: avatar,
                        child: InkWell(
                          onTap: () => setState(() => _avatar = avatar),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentGreen.withValues(
                                alpha: 0.22,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _avatar == avatar
                                    ? AppTheme.primaryDark
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: Image.asset('assets/avatars/$avatar.png'),
                          ),
                        ),
                      ),
                    )
                    .toList(),
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
              ),
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
