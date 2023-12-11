import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/providers/theme_switch.dart';
import 'package:todo_app/screens/signup.dart';
import 'package:todo_app/screens/splash.dart';

import 'widgets/start_app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(requestAlertPermission: true);
  InitializationSettings initializationSettings = const InitializationSettings(
    android: null,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await ScreenUtil.ensureScreenSize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late Future<FirebaseApp> _initialization;
  late List<ThemeData> _themes;

  @override
  initState() {
    super.initState();
    _initialization = Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _generateThemes();
  }

  void _generateThemes() {
    final themes = <ThemeData>[];
    for (final brightness in {Brightness.light, Brightness.dark}) {
      themes.add(ThemeData(
          brightness: brightness,
          colorSchemeSeed: Colors.orange,
          textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
              headlineLarge: TextStyle(
            fontWeight: FontWeight.w600,
          )))));
    }
    _themes = themes;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    final brightness = ref.watch(themeSwitchProvider);
    final themeMode = switch (brightness) {
      Brightness.light => ThemeMode.light,
      Brightness.dark => ThemeMode.dark,
    };
    return FutureBuilder(
        future: _initialization,
        builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
          final isFirebaseReady =
              snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData;
          return MaterialApp(
              title: 'Todo App',
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
              theme: _themes[0],
              darkTheme: _themes[1],
              home: isFirebaseReady ? const StartApp() : const SplashScreen(),
              routes: {
                '/auth': (ctx) => const SignUpForm(),
                '/splash': (ctx) => const SplashScreen(),
              });
        });
  }
}
