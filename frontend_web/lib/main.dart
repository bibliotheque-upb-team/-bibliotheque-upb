import 'package:flutter/material.dart';
import 'screens/auth_screen_web.dart';
import 'screens/biblio/biblio_app.dart';
import 'screens/admin/admin_app.dart';

void main() => runApp(const BibliothequeWebApp());

class BibliothequeWebApp extends StatelessWidget {
  const BibliothequeWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliothèque UPB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF59E0B)),
      ),
      home: const AuthScreenWeb(),
      routes: {
        '/login': (_) => const AuthScreenWeb(),
        '/biblio': (_) => const BiblioApp(),
        '/admin': (_) => const AdminApp(),
      },
    );
  }
}
