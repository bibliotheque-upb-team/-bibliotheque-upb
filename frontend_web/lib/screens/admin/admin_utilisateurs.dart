import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/service_locator.dart';

class AdminUtilisateurs extends StatefulWidget {
  const AdminUtilisateurs({super.key});
  @override
  State<AdminUtilisateurs> createState() => _AdminUtilisateursState();
}

class _AdminUtilisateursState extends State<AdminUtilisateurs> {
  List<dynamic> _utilisateurs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    try {
      final u = await Services.admin.listerUtilisateurs();
      if (mounted) setState(() { _utilisateurs = u; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _toggleStatut(dynamic id, bool actuel) async {
    await Services.admin.changerStatut(id, !actuel);
    await _charger();
  }

  Color _roleColor(String? type) {
    switch (type) {
      case 'ADMINISTRATEUR': return const Color(0xFF6366F1);
      case 'BIBLIOTHECAIRE': return const Color(0xFFF59E0B);
      default: return const Color(0xFF3B82F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gestion des utilisateurs', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            _loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1)))
                : Expanded(
                    child: ListView.builder(
                      itemCount: _utilisateurs.length,
                      itemBuilder: (context, i) {
                        final u = _utilisateurs[i];
                        final actif = u['actif'] == true;
                        final type = u['type_utilisateur'] ?? 'ETUDIANT';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            CircleAvatar(
                              backgroundColor: _roleColor(type).withValues(alpha: 0.15),
                              child: Text(
                                '${u['prenom']?[0] ?? ''}${u['nom']?[0] ?? ''}'.toUpperCase(),
                                style: TextStyle(color: _roleColor(type), fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('${u['prenom'] ?? ''} ${u['nom'] ?? ''}',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                Text(u['identifiant'] ?? '', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
                                Text(u['email'] ?? '', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF94A3B8))),
                              ]),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _roleColor(type).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(type, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: _roleColor(type))),
                            ),
                            const SizedBox(width: 12),
                            Switch(
                              value: actif,
                              onChanged: (_) => _toggleStatut(u['utilisateurId'], actif),
                              activeThumbColor: const Color(0xFF10B981),
                            ),
                            Text(actif ? 'Actif' : 'Désactivé',
                                style: GoogleFonts.inter(fontSize: 12, color: actif ? Colors.green : Colors.red)),
                          ]),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
