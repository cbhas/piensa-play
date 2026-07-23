import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // generado por flutterfire configure
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/services/auth_service.dart';
import 'core/services/firestore_provider.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/logger_service.dart';
import 'core/services/user_id_provider.dart';
import 'core/services/notification_service.dart';
import 'core/services/widget_service.dart';
import 'core/widgets/offline_banner.dart';
import 'core/localization/app_locale.dart';
import 'core/accessibility/accessibility_controller.dart';
import 'core/routes/app_routes.dart';
import 'features/missions/presentation/pages/missions_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserIdProvider.initialize();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firestore (caché/persistencia) en un solo lugar.
  FirestoreProvider.configure();

  // Detección de conectividad (para el indicador offline).
  await ConnectivityService.instance.initialize();

  // El arranque no debe fallar por problemas de red: una primera apertura sin
  // conexión sigue funcionando con el id de instalación local y la caché.
  try {
    await AuthService().ensureSignedIn();
  } catch (error) {
    AppLogger.warning('AUTH: continuing with offline installation ID: $error');
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

  String _resolveInitialRoute() {
    if (kIsWeb) {
      final path = Uri.tryParse(Uri.base.fragment)?.path;
      if (path != null && AppRoutes.routes.containsKey(path)) return path;
    }
    return AppRoutes.splash;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLocaleController()..load()),
        ChangeNotifierProvider(
          create: (_) => AccessibilityController()..load(),
        ),
      ],
      child:
          Consumer3<
            ThemeProvider,
            AppLocaleController,
            AccessibilityController
          >(
            builder:
                (context, themeProvider, localeProvider, accessibility, child) {
                  return MaterialApp(
                    title: 'PiensaPlay',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeProvider.themeMode,
                    locale: localeProvider.locale,
                    supportedLocales: const [Locale('es'), Locale('en')],
                    localizationsDelegates: const [
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    builder: (context, child) {
                      final media = MediaQuery.of(context);
                      // Accesibilidad (main) envolviendo el aviso de sin
                      // conexión (offline-first): ambos deben aplicarse.
                      return MediaQuery(
                        data: media.copyWith(
                          textScaler: TextScaler.linear(
                            accessibility.textScale,
                          ),
                          disableAnimations:
                              accessibility.reducedMotion ||
                              media.disableAnimations,
                        ),
                        child: OfflineBanner(
                          child: child ?? const SizedBox.shrink(),
                        ),
                      );
                    },
                    initialRoute: _resolveInitialRoute(),
                    onGenerateInitialRoutes: (initialRoute) {
                      final routes = AppRoutes.routes;
                      final builder =
                          routes[initialRoute] ?? routes[AppRoutes.splash]!;
                      return [
                        MaterialPageRoute<void>(
                          settings: RouteSettings(name: initialRoute),
                          builder: builder,
                        ),
                      ];
                    },
                    routes: AppRoutes.routes,
                    navigatorObservers: [routeObserver],
                    debugShowCheckedModeBanner: false,
                  );
                },
          ),
    );
  }
}
