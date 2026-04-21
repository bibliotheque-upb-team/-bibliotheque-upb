import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblio_upb/services/service_locator.dart';
import 'package:biblio_upb/models/livre.dart';

class EtudiantHome extends StatefulWidget {
  const EtudiantHome({super.key});
  @override
  State<EtudiantHome> createState() => _EtudiantHomeState();
}

class _EtudiantHomeState extends State<EtudiantHome> {
  List<Livre> _livresPopulaires = [];
  bool _loading = true;
  String _userName = '';
  int _empruntsEnCours = 0;
  int _reservationsEnAttente = 0;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      final userId = await Services.auth.getUserId();
      final userName = await Services.auth.getUserName();
      final livres = await Services.livres.listerTous();
      List emprunts = [];
      List reservations = [];
      if (userId != null) {
        emprunts = await Services.emprunts.mesEmprunts(userId);
        reservations = await Services.emprunts.mesReservations(userId);
      }
      setState(() {
        _livresPopulaires = livres.take(6).toList();
        _empruntsEnCours = emprunts.length;
        _reservationsEnAttente = reservations.length;
        _userName = userName ?? 'Étudiant';
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _chargerDonnees,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carte de bienvenue
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bonjour 👋', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                    Text(_userName, style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _statCard('📚', '$_empruntsEnCours', 'Emprunts'),
                        const SizedBox(width: 12),
                        _statCard('🔖', '$_reservationsEnAttente', 'Réservations'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Bibliothèque virtuelle
              Text('Ma Bibliothèque 3D', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A5F))),
              const SizedBox(height: 12),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('📚', style: TextStyle(fontSize: 48)),
                      Text('Bibliothèque Virtuelle', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Livres populaires
              Text('Livres disponibles', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A5F))),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: _livresPopulaires.length,
                itemBuilder: (context, index) {
                  final livre = _livresPopulaires[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(child: Text('📖', style: TextStyle(fontSize: 32))),
                          ),
                          const SizedBox(height: 8),
                          Text(livre.titre, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                          Text(livre.auteur, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: livre.estDisponible ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              livre.estDisponible ? 'Disponible' : 'Indisponible',
                              style: TextStyle(color: livre.estDisponible ? Colors.green : Colors.red, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}