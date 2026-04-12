import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiblioCatalogue extends StatefulWidget {
  const BiblioCatalogue({super.key});

  @override
  State<BiblioCatalogue> createState() => _BiblioCatalogueState();
}

class _BiblioCatalogueState extends State<BiblioCatalogue> {
  final List<Map<String, dynamic>> _livres = [
    {'id': 1, 'titre': 'Algorithmique', 'auteur': 'Cormen', 'categorie': 'Informatique', 'disponible': true},
    {'id': 2, 'titre': 'Calcul Différentiel', 'auteur': 'Stewart', 'categorie': 'Mathématiques', 'disponible': false},
    {'id': 3, 'titre': 'Physique Générale', 'auteur': 'Halliday', 'categorie': 'Sciences', 'disponible': true},
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Catalogue',
                    style: GoogleFonts.inter(
                        fontSize: 24, fontWeight: FontWeight.w700)),
                ElevatedButton.icon(
                  onPressed: () => _afficherFormulaire(context),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text('Ajouter un livre',
                      style: GoogleFonts.inter(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: _livres.length,
                itemBuilder: (context, index) {
                  final livre = _livres[index];
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
                              Text(livre['titre'],
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600)),
                              Text(livre['auteur'],
                                  style: GoogleFonts.inter(
                                      color: const Color(0xFF94A3B8))),
                              Text(livre['categorie'],
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFFF59E0B))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: livre['disponible']
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            livre['disponible'] ? 'Disponible' : 'Emprunté',
                            style: TextStyle(
                              color: livre['disponible']
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _afficherFormulaire(context, livre: livre),
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
    setState(() => _livres.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livre supprimé !')),
    );
  }

  void _afficherFormulaire(BuildContext context, {Map<String, dynamic>? livre}) {
    final titreController = TextEditingController(text: livre?['titre'] ?? '');
    final auteurController = TextEditingController(text: livre?['auteur'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(livre == null ? 'Ajouter un livre' : 'Modifier le livre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titreController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: auteurController,
              decoration: const InputDecoration(labelText: 'Auteur'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (livre == null) {
                  _livres.add({
                    'id': _livres.length + 1,
                    'titre': titreController.text,
                    'auteur': auteurController.text,
                    'categorie': 'Général',
                    'disponible': true,
                  });
                } else {
                  livre['titre'] = titreController.text;
                  livre['auteur'] = auteurController.text;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B)),
            child: const Text('Enregistrer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}