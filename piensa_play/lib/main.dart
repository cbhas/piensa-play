import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // generado por flutterfire configure
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_provider.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/widget_service.dart';
import 'core/widgets/offline_banner.dart';
import 'core/routes/app_routes.dart';
import 'features/missions/presentation/pages/missions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firestore (caché/persistencia) en un solo lugar.
  FirestoreProvider.configure();

  // Detección de conectividad (para el indicador offline).
  await ConnectivityService.instance.initialize();

  // El arranque no debe fallar por problemas de red: ensureSignedIn ya es
  // resiliente, pero envolvemos por seguridad para no romper nunca el inicio.
  try {
    await AuthService().ensureSignedIn();
  } catch (_) {
    // La app continúa con datos cacheados / id de respaldo.
  }

  if (!kIsWeb) {
    // Initialize notifications + home widget (Mobile only), en paralelo.
    await Future.wait([
      NotificationService().initialize(),
      WidgetService().initialize(),
    ]);
  }

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
            builder: (context, child) =>
                OfflineBanner(child: child ?? const SizedBox.shrink()),
          );
        },
      ),
    );
  }
}
