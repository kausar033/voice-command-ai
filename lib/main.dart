import 'package:flutter/material.dart';
import 'package:flutter_ai/injection_container.dart' as di;
import 'package:flutter_ai/presentation/screens/home_screen.dart';
import 'package:flutter_ai/core/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.sl<NotificationService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Order',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFf6f8f6),
        primaryColor: const Color(0xFF13ec5b),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF13ec5b),
          surface: Color(0xFFffffff),
          onSurface: Color(0xFF111813),
          secondary: Color(0xFF13ec5b),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
