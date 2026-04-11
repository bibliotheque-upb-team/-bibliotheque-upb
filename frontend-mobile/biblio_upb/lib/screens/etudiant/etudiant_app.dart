import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblio_upb/screens/etudiant/etudiant_home.dart';
import 'package:biblio_upb/screens/etudiant/etudiant_catalogue.dart';
import 'package:biblio_upb/services/service_locator.dart';

class EtudiantApp extends StatefulWidget {
  const EtudiantApp({super.key});
  @override
  State<EtudiantApp> createState() => _EtudiantAppState();
}

class _EtudiantAppState extends State<EtudiantApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const EtudiantHome(),
    const EtudiantCatalogue(),
    const Scaffold(body: Center(child: Text('Mes Livres - Séance 7'))),
    const Scaffold(body: Center(child: Text('Jeux - Séance 7'))),
    const Scaffold(body: Center(child: Text('Profil - Séance 7'))),
  ];

  Future<void> _deconnexion() async {
    await Services.auth.deconnexion();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        title: Text('Bibliothèque UPB', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _deconnexion,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'Catalogue'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mes Livres'),
          BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Jeux'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}