import 'package:flutter/material.dart';
import 'biblio_dashboard.dart';
import 'biblio_catalogue.dart';
import 'biblio_reservations.dart';
import 'biblio_moderation.dart';
import 'biblio_informer.dart';

class BiblioApp extends StatefulWidget {
  const BiblioApp({super.key});

  @override
  State<BiblioApp> createState() => _BiblioAppState();
}

class _BiblioAppState extends State<BiblioApp> {
  int _page = 0;

  final _tabs = [
    {'icon': Icons.dashboard, 'label': 'Tableau de bord'},
    {'icon': Icons.library_books, 'label': 'Catalogue'},
    {'icon': Icons.bookmark, 'label': 'Réservations'},
    {'icon': Icons.rate_review, 'label': 'Modération'},
    {'icon': Icons.send, 'label': 'Informer'},
  ];

  final _pages = const [
    BiblioDashboard(),
    BiblioCatalogue(),
    BiblioReservations(),
    BiblioModeration(),
    BiblioInformer(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          Container(
            width: 240,
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_library,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'UPB Biblio',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bibliothécaire',
                  style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(height: 32),
                ..._tabs.asMap().entries.map((e) {
                  final i = e.key;
                  final t = e.value;
                  final active = _page == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: Icon(
                        t['icon'] as IconData,
                        color: active
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF94A3B8),
                        size: 20,
                      ),
                      title: Text(
                        t['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                          color: active
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF64748B),
                        ),
                      ),
                      selected: active,
                      selectedTileColor: const Color(0xFFFEF3C7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onTap: () => setState(() => _page = i),
                    ),
                  );
                }),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout,
                      color: Color(0xFFEF4444), size: 20),
                  title: const Text(
                    'Déconnexion',
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFFEF4444)),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                ),
              ],
            ),
          ),
          Expanded(child: _pages[_page]),
        ],
      ),
    );
  }
}