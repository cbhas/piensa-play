// lib/features/settings/presentation/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../home/presentation/widgets/custom_bottom_nav_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
            ),
            child: const Text(
              'Ajustes',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).slideFromTop(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance Section
                  Text(
                    'Apariencia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.primaryDark,
                    ),
                  ).fadeInSlide(delay: const Duration(milliseconds: 100)),

                  const SizedBox(height: 12),

                  // Dark Mode Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SwitchListTile(
                      title: Text(
                        'Modo Oscuro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppTheme.textPrimaryDark
                              : AppTheme.primaryDark,
                        ),
                      ),
                      subtitle: Text(
                        isDark ? 'Activado' : 'Desactivado',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppTheme.textSecondaryDark
                              : Colors.grey.shade600,
                        ),
                      ),
                      value: isDark,
                      onChanged: (_) => themeProvider.toggleTheme(),
                      activeThumbColor: AppTheme.accentGreen,
                      secondary: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark
                            ? AppTheme.accentYellow
                            : AppTheme.accentBlue,
                      ),
                    ),
                  ).fadeInSlide(delay: const Duration(milliseconds: 200)),

                  const SizedBox(height: 32),

                  // Account Section (Placeholder)
                  Text(
                    'Cuenta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.primaryDark,
                    ),
                  ).fadeInSlide(delay: const Duration(milliseconds: 300)),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: isDark
                                ? AppTheme.accentBlue
                                : AppTheme.primaryDark,
                          ),
                          title: Text(
                            'Perfil',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.primaryDark,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to profile
                          },
                        ),
                        Divider(
                          height: 1,
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.notifications,
                            color: isDark
                                ? AppTheme.accentYellow
                                : AppTheme.primaryDark,
                          ),
                          title: Text(
                            'Notificaciones',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.primaryDark,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to notifications
                          },
                        ),
                      ],
                    ),
                  ).fadeInSlide(delay: const Duration(milliseconds: 400)),

                  const SizedBox(height: 32),

                  // About Section (Placeholder)
                  Text(
                    'Acerca de',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.primaryDark,
                    ),
                  ).fadeInSlide(delay: const Duration(milliseconds: 500)),

                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: isDark
                                ? AppTheme.accentGreen
                                : AppTheme.primaryDark,
                          ),
                          title: Text(
                            'Versión',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.primaryDark,
                            ),
                          ),
                          trailing: Text(
                            '1.0.0',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textSecondaryDark
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.grey.shade300,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.help,
                            color: isDark
                                ? AppTheme.accentPink
                                : AppTheme.primaryDark,
                          ),
                          title: Text(
                            'Ayuda',
                            style: TextStyle(
                              color: isDark
                                  ? AppTheme.textPrimaryDark
                                  : AppTheme.primaryDark,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Navigate to help
                          },
                        ),
                      ],
                    ),
                  ).fadeInSlide(delay: const Duration(milliseconds: 600)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/glossary');
          }
          // index == 2 is already on settings
        },
      ),
    );
  }
}
