import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAudits extends StatefulWidget {
  const AdminAudits({super.key});
  @override
  State<AdminAudits> createState() => _AdminAuditsState();
}

class _AdminAuditsState extends State<AdminAudits> {
  final _search = TextEditingController();

  final List<Map<String, dynamic>> _audits = [
    {
      'action': 'CONNEXION',
      'description': 'Connexion réussie',
      'emailUtilisateur': 'melakpa222@gmail.com',
      'roleUtilisateur': 'ETUDIANT',
      'dateAction': '2026-04-12T10:30:00',
    },
    {
      'action': 'EMPRUNT',
      'description': 'Emprunt du livre Algorithmique',
      'emailUtilisateur': 'bamba@gmail.com',
      'roleUtilisateur': 'ETUDIANT',
      'dateAction': '2026-04-12T11:00:00',
    },
    {
      'action': 'VALIDATION',
      'description': 'Validation réservation #3',
      'emailUtilisateur': 'sophie@gmail.com',
      'roleUtilisateur': 'BIBLIOTHECAIRE',
      'dateAction': '2026-04-12T12:00:00',
    },
    {
      'action': 'SUPPRESSION',
      'description': 'Suppression annotation #5',
      'emailUtilisateur': 'sophie@gmail.com',
      'roleUtilisateur': 'BIBLIOTHECAIRE',
      'dateAction': '2026-04-12T13:00:00',
    },
  ];

  List<Map<String, dynamic>> get _filtres {
    if (_search.text.isEmpty) return _audits;
    final q = _search.text.toLowerCase();
    return _audits.where((a) =>
    (a['action'] ?? '').toLowerCase().contains(q) ||
        (a['description'] ?? '').toLowerCase().contains(q) ||
        (a['emailUtilisateur'] ?? '').toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Journaux d\'Audit',
              style: GoogleFonts.inter(
                  fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          SizedBox(
            width: 400,
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,
                      color: Color(0xFF94A3B8)),
                  hintText: 'Rechercher par action, email...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none)),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
                itemCount: _filtres.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final a = _filtres[i];
                  return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        Container(
                            width: 120,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(a['action'] ?? '',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFF59E0B)),
                                textAlign: TextAlign.center)),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a['description'] ?? '',
                                      style: GoogleFonts.inter(fontSize: 13)),
                                  Text(
                                      '${a['emailUtilisateur']} · ${a['roleUtilisateur']}',
                                      style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: const Color(0xFF94A3B8))),
                                ])),
                        Text(
                            (a['dateAction'] ?? '')
                                .toString()
                                .substring(0, 16)
                                .replaceFirst('T', ' '),
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                color: const Color(0xFFCBD5E1))),
                      ]));
                }),
          ),
        ],
      ),
    );
  }
}