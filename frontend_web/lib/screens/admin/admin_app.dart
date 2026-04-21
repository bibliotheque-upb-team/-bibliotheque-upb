import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_audits.dart';
import 'admin_dashboard.dart';
import 'admin_utilisateurs.dart';

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});
  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  int _page = 0;

  final _tabs = [
    {'icon': Icons.dashboard, 'label': 'Tableau de bord'},
    {'icon': Icons.people, 'label': 'Utilisateurs'},
    {'icon': Icons.history, 'label': 'Journaux d\'audit'},
  ];

  final _pages = [
    const AdminDashboard(),
    const AdminUtilisateurs(),
    const AdminAudits(),
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
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('UPB Admin', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: const Color(0xFF6366F1))),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Administrateur', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                const SizedBox(height: 32),
                ..._tabs.asMap().entries.map((e) {
                  final i = e.key;
                  final t = e.value;
                  final active = _page == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: Icon(t['icon'] as IconData,
                          color: active ? const Color(0xFF6366F1) : const Color(0xFF94A3B8), size: 20),
                      title: Text(t['label'] as String,
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
                      selected: active,
                      selectedTileColor: const Color(0xFFEEF2FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onTap: () => setState(() => _page = i),
                    ),
                  );
                }),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                  title: Text('Déconnexion', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFEF4444))),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
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
