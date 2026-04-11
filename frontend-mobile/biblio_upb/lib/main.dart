import 'package:flutter/material.dart';
import 'package:biblio_upb/screens/auth_screen.dart';
void main() => runApp(const BibliothequeApp());

class BibliothequeApp extends StatelessWidget {
  const BibliothequeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bibliothèque UPB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
      ),
      home: const AuthScreen(),
      routes: {
        '/login': (_) => const AuthScreen(),
        '/etudiant': (_) => const Scaffold(body: Center(child: Text('Séance 6'))),
      },
    );
  }
}