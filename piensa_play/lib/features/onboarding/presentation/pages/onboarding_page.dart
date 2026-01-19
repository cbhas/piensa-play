// lib/features/onboarding/presentation/pages/onboarding_page.dart

import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/mascot_audio_button.dart';
import '../../../../core/services/audio_service.dart';
import '../../domain/entities/avatar.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_avatars.dart';
import '../../domain/usecases/save_user_profile.dart';
import '../widgets/avatar_selector.dart';
import '../widgets/animated_bubble.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final GetAvatars _getAvatars = GetAvatars();
  final SaveUserProfile _saveUserProfile = SaveUserProfile();

  String? _selectedAvatarId;
  int? _selectedAge;
  List<Avatar> _avatars = [];

  @override
  void initState() {
    super.initState();
    _avatars = _getAvatars.execute();

    // Auto-play profile audio
    _playProfileAudio();
  }

  Future<void> _playProfileAudio() async {
    try {
      await AudioService().playMascotAudio('perfil.mp3');
    } catch (e) {
      AppLogger.error('Error playing profile audio: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleAvatarSelection(String avatarId) {
    setState(() {
      _selectedAvatarId = avatarId;
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAge == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Por favor selecciona tu edad'),
            backgroundColor: AppTheme.primaryDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Generar código de estudiante único
      final studentCode = UserProfile.generateStudentCode();

      final profile = UserProfile(
        name: _nameController.text,
        age: _selectedAge!,
        avatarId: _selectedAvatarId!,
        studentCode: studentCode,
      );

      AppLogger.log(
        'Guardando perfil: nombre=${profile.name}, edad=${profile.age}, avatarId=${profile.avatarId}, studentCode=${profile.studentCode}',
      );

      await _saveUserProfile.execute(profile);

      AppLogger.success('Perfil guardado exitosamente');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : Colors.white,
      body: Stack(
        children: [
          // Burbujas decorativas animadas
          _buildDecorativeBubbles(),

          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Logo con imagen p.png
                      Container(
                        child: Center(
                          child: ClipOval(
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/p.png',
                                  width: 100,
                                  height: 100,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Título y botón de audio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '¡Cuéntanos sobre ti!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const MascotAudioButton(
                            audioFileName: 'perfil.mp3',
                            size: 45,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Contenedor del formulario con borde dorado
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFC4B454),
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Para personalizar tu aventura:',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Campo de nombre
                            TextFormField(
                              controller: _nameController,
                              style: TextStyle(
                                color: AppTheme.primaryDark,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: '¿Cómo te llamas?',
                                hintStyle: TextStyle(
                                  color: AppTheme.primaryDark.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8F4F8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD0E8F0),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryDark.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu nombre';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            // Selector de edad (dropdown)
                            DropdownButtonFormField<int>(
                              initialValue: _selectedAge,
                              decoration: InputDecoration(
                                hintText: '¿Cuántos años tienes?',
                                hintStyle: TextStyle(
                                  color: AppTheme.primaryDark.withValues(
                                    alpha: 0.4,
                                  ),
                                  fontSize: 16,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFE8F4F8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFD0E8F0),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryDark.withValues(
                                      alpha: 0.5,
                                    ),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                              ),
                              items: List.generate(9, (index) {
                                final age = index + 4;
                                return DropdownMenuItem<int>(
                                  value: age,
                                  child: Text(
                                    'Tengo $age años',
                                    style: TextStyle(
                                      color: AppTheme.primaryDark,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }),
                              onChanged: (value) {
                                setState(() {
                                  _selectedAge = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Por favor selecciona tu edad';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Título selector de avatar
                      Text(
                        '¡Elige tu Avatar!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Grid de avatares
                      AvatarSelector(
                        avatars: _avatars,
                        selectedAvatarId: _selectedAvatarId,
                        onAvatarSelected: _handleAvatarSelection,
                      ),

                      const SizedBox(height: 20),

                      // Botón "¡A Jugar!"
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA0E69D),
                            foregroundColor: AppTheme.tertiaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            '¡A Jugar!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.tertiaryDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Texto informativo
                      Text(
                        'Solo usamos esta información para personalizar tu\nexperiencia.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Link de recuperación
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/recover');
                        },
                        child: Text(
                          '¿Tienes un código de recuperación?',
                          style: TextStyle(
                            color: AppTheme.primaryDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Burbujas decorativas animadas
  Widget _buildDecorativeBubbles() {
    return Stack(
      children: [
        // Burbuja superior izquierda
        AnimatedBubble(size: 200, top: -80, left: -80, duration: 4, offset: 20),

        // Burbuja inferior derecha
        AnimatedBubble(
          size: 250,
          bottom: -100,
          right: -100,
          duration: 5,
          offset: 25,
        ),

        // Burbuja centro derecha
        AnimatedBubble(
          size: 180,
          right: -60,
          centerVertically: true,
          duration: 4.5,
          offset: 15,
        ),
      ],
    );
  }
}
