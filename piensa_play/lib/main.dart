import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // generado por flutterfire configure
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/auth_service.dart';
import 'core/routes/app_routes.dart';
import 'features/missions/presentation/pages/missions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firestore with offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Enable offline persistence (default on mobile)
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, // Unlimited cache size
  );

  final authService = AuthService();
  await authService.ensureSignedIn();

  runApp(const PiensaPlayApp());
}

class PiensaPlayApp extends StatelessWidget {
  const PiensaPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Piensa Play',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
            navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
