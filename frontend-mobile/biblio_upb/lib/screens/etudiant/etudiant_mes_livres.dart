import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblio_upb/services/service_locator.dart';
import 'package:biblio_upb/models/emprunt.dart';
import 'package:biblio_upb/models/reservation.dart';

class EtudiantMesLivres extends StatefulWidget {
  const EtudiantMesLivres({super.key});
  @override
  State<EtudiantMesLivres> createState() => _EtudiantMesLivresState();
}

class _EtudiantMesLivresState extends State<EtudiantMesLivres> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Emprunt> _emprunts = [];
  List<Reservation> _reservations = [];
  bool _loading = true;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      _userId = await Services.auth.getUserId();
      if (_userId != null) {
        final emprunts = await Services.emprunts.mesEmprunts(_userId!);
        final reservations = await Services.emprunts.mesReservations(_userId!);
        setState(() {
          _emprunts = emprunts;
          _reservations = reservations;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  Future<void> _retourner(int empruntId) async {
    try {
      await Services.emprunts.retourner(empruntId);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livre retourné avec succès !'), backgroundColor: Colors.green));
      _chargerDonnees();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _prolonger(int empruntId) async {
    if (_userId == null) return;
    try {
      await Services.emprunts.prolonger(empruntId, _userId!);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Emprunt prolongé !'), backgroundColor: Colors.green));
      _chargerDonnees();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red));
    }
  }

  Future<void> _annulerReservation(int reservationId) async {
    try {
      await Services.emprunts.annulerReservation(reservationId);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Réservation annulée !'), backgroundColor: Colors.orange));
      _chargerDonnees();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF2563EB),
          tabs: const [
            Tab(text: 'Mes Emprunts'),
            Tab(text: 'Mes Réservations'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          // Onglet Emprunts
          RefreshIndicator(
            onRefresh: _chargerDonnees,
            child: _emprunts.isEmpty
                ? const Center(child: Text('Aucun emprunt en cours'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _emprunts.length,
              itemBuilder: (context, index) {
                final emprunt = _emprunts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('📖', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(emprunt.titreLivre, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                  Text('Retour prévu : ${emprunt.dateRetourPrevue}',
                                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: emprunt.enRetard ? Colors.red.shade50 : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                emprunt.enRetard ? 'En retard' : 'En cours',
                                style: TextStyle(
                                    color: emprunt.enRetard ? Colors.red : Colors.green,
                                    fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: emprunt.empruntId == null ? null : () => _retourner(emprunt.empruntId!),
                                icon: const Icon(Icons.assignment_return, size: 16),
                                label: const Text('Retourner'),
                                style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF2563EB)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (emprunt.peutProlonger && !emprunt.enRetard)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: emprunt.empruntId == null ? null : () => _prolonger(emprunt.empruntId!),
                                  icon: const Icon(Icons.update, size: 16),
                                  label: const Text('Prolonger'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      foregroundColor: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Onglet Réservations
          RefreshIndicator(
            onRefresh: _chargerDonnees,
            child: _reservations.isEmpty
                ? const Center(child: Text('Aucune réservation en attente'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _reservations.length,
              itemBuilder: (context, index) {
                final reservation = _reservations[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Text('🔖', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reservation.titreLivre, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                              Text('Position : ${reservation.positionFileAttente}',
                                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: reservation.reservationId == null ? null : () => _annulerReservation(reservation.reservationId!),
                          child: const Text('Annuler', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}