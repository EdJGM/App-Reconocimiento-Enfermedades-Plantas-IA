import 'package:flutter/material.dart';
import 'package:rec_enfermedades_plantas_ia/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detección de enfermedades de las plantas',
      theme: ThemeData(
        primaryColor: const Color(0xFF8BC34A),
        scaffoldBackgroundColor: const Color(0xFF8BC34A),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),  // Replaced headline6 with titleLarge
          bodyMedium: TextStyle(color: Colors.blueGrey),  // Replaced bodyText2 with bodyMedium
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8BC34A),
          elevation: 0,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF5FA709),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF5CAB00)),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

