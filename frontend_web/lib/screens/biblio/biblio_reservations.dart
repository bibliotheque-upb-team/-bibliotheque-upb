import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiblioReservations extends StatefulWidget {
  const BiblioReservations({super.key});

  @override
  State<BiblioReservations> createState() => _BiblioReservationsState();
}

class _BiblioReservationsState extends State<BiblioReservations> {
  final List<Map<String, dynamic>> _reservations = [
    {'id': 1, 'etudiant': 'Akpa Metch Mel', 'livre': 'Algorithmique', 'date': '11/04/2026', 'statut': 'EN_ATTENTE'},
    {'id': 2, 'etudiant': 'Bamba Yacouba', 'livre': 'Physique Générale', 'date': '11/04/2026', 'statut': 'EN_ATTENTE'},
    {'id': 3, 'etudiant': 'Sophie Martin', 'livre': 'Calcul Différentiel', 'date': '10/04/2026', 'statut': 'EN_ATTENTE'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Réservations',
                style: GoogleFonts.inter(
                    fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  final resa = _reservations[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(resa['etudiant'],
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600)),
                              Text(resa['livre'],
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFF94A3B8))),
                              Text(resa['date'],
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF94A3B8))),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _valider(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Valider',
                              style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _refuser(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Refuser',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _valider(int index) {
    setState(() => _reservations.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Réservation validée !')),
    );
  }

  void _refuser(int index) {
    setState(() => _reservations.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Réservation refusée !')),
    );
  }
}