// lib/features/onboarding/presentation/pages/onboarding_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
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
  final _ageController = TextEditingController();

  final GetAvatars _getAvatars = GetAvatars();
  final SaveUserProfile _saveUserProfile = SaveUserProfile();

  String? _selectedAvatarId;
  List<Avatar> _avatars = [];

  @override
  void initState() {
    super.initState();
    _avatars = _getAvatars.execute();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _handleAvatarSelection(String avatarId) {
    setState(() {
      _selectedAvatarId = avatarId;
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAvatarId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Por favor selecciona un avatar'),
            backgroundColor: AppTheme.primaryDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final profile = UserProfile(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        avatarId: _selectedAvatarId!,
      );

      print('🔵 Guardando perfil: nombre=${profile.name}, edad=${profile.age}, avatarId=${profile.avatarId}');

      await _saveUserProfile.execute(profile);

      print('🟢 Perfil guardado exitosamente');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            child: Container(
                              width: 130,
                              height: 130,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/p.png',
                                  width: 130,
                                  height: 130,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Título
                      Text(
                        '¡Cuéntanos sobre ti!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),

                      const SizedBox(height: 32),

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
                                  color: AppTheme.primaryDark.withOpacity(0.4),
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
                                    color: AppTheme.primaryDark.withOpacity(0.5),
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

                            const SizedBox(height: 14),

                            // Campo de edad
                            TextFormField(
                              controller: _ageController,
                              style: TextStyle(
                                color: AppTheme.primaryDark,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: '¿Cuántos años tienes?',
                                hintStyle: TextStyle(
                                  color: AppTheme.primaryDark.withOpacity(0.4),
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
                                    color: AppTheme.primaryDark.withOpacity(0.5),
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
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa tu edad';
                                }
                                final age = int.tryParse(value);
                                if (age == null || age < 8 || age > 12) {
                                  return 'La edad debe estar entre 8 y 12 años';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Título selector de avatar
                      Text(
                        '¡Elige tu Avatar!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Grid de avatares
                      AvatarSelector(
                        avatars: _avatars,
                        selectedAvatarId: _selectedAvatarId,
                        onAvatarSelected: _handleAvatarSelection,
                      ),

                      const SizedBox(height: 32),

                      // Botón "¡A Jugar!"
                      SizedBox(
                        width: double.infinity,
                        height: 60,
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.tertiaryDark,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

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

                      const SizedBox(height: 32),
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
        AnimatedBubble(
          size: 200,
          top: -80,
          left: -80,
          duration: 4,
          offset: 20,
        ),

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
