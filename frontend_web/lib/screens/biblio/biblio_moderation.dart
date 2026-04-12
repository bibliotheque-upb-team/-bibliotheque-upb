import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiblioModeration extends StatefulWidget {
  const BiblioModeration({super.key});

  @override
  State<BiblioModeration> createState() => _BiblioModerationState();
}

class _BiblioModerationState extends State<BiblioModeration> {
  final List<Map<String, dynamic>> _annotations = [
    {
      'id': 1,
      'etudiant': 'Akpa Metch Mel',
      'livre': 'Algorithmique',
      'page': 42,
      'texte': 'Cette partie est très intéressante !'
    },
    {
      'id': 2,
      'etudiant': 'Bamba Yacouba',
      'livre': 'Physique Générale',
      'page': 15,
      'texte': 'Je ne comprends pas ce chapitre.'
    },
    {
      'id': 3,
      'etudiant': 'Sophie Martin',
      'livre': 'Calcul Différentiel',
      'page': 78,
      'texte': 'Excellente démonstration !'
    },
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
            Text('Modération',
                style: GoogleFonts.inter(
                    fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _annotations.length,
                itemBuilder: (context, index) {
                  final annotation = _annotations[index];
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
                              Row(
                                children: [
                                  Text(annotation['etudiant'],
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 8),
                                  Text('•',
                                      style: GoogleFonts.inter(
                                          color: const Color(0xFF94A3B8))),
                                  const SizedBox(width: 8),
                                  Text(annotation['livre'],
                                      style: GoogleFonts.inter(
                                          color: const Color(0xFFF59E0B))),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('Page ${annotation['page']}',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF94A3B8))),
                              const SizedBox(height: 4),
                              Text(annotation['texte'],
                                  style: GoogleFonts.inter(fontSize: 13)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimer(index),
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

  void _supprimer(int index) {
    setState(() => _annotations.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Annotation supprimée !')),
    );
  }
}