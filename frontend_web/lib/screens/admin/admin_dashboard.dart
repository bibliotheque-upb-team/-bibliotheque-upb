import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/service_locator.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final s = await Services.admin.dashboard();
      if (mounted) setState(() { _stats = s; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tableau de bord Administrateur',
                      style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text('Vue globale de la bibliothèque UPB',
                      style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF94A3B8))),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 16, runSpacing: 16,
                    children: [
                      _StatCard(label: 'Étudiants', value: '${_stats?['etudiants'] ?? 0}',
                          icon: Icons.school, color: const Color(0xFF3B82F6)),
                      _StatCard(label: 'Bibliothécaires', value: '${_stats?['bibliothecaires'] ?? 0}',
                          icon: Icons.manage_accounts, color: const Color(0xFFF59E0B)),
                      _StatCard(label: 'Administrateurs', value: '${_stats?['administrateurs'] ?? 0}',
                          icon: Icons.admin_panel_settings, color: const Color(0xFF6366F1)),
                      _StatCard(label: 'Total Livres', value: '${_stats?['totalLivres'] ?? 0}',
                          icon: Icons.menu_book, color: const Color(0xFF10B981)),
                      _StatCard(label: 'Emprunts en retard', value: '${_stats?['empruntsEnRetard'] ?? 0}',
                          icon: Icons.warning_amber, color: const Color(0xFFEF4444)),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(height: 12),
        Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: const Color(0xFF0F172A))),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
      ]),
    );
  }
}
