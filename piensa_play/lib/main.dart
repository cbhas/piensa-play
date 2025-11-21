import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // generado por flutterfire configure
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PiensaPlayApp());
}

class PiensaPlayApp extends StatelessWidget {
  const PiensaPlayApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiensaPlay',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
