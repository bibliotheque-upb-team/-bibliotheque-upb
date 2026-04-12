import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblio_upb/services/service_locator.dart';
import 'package:biblio_upb/models/notification_model.dart';

class EtudiantProfil extends StatefulWidget {
  const EtudiantProfil({super.key});
  @override
  State<EtudiantProfil> createState() => _EtudiantProfilState();
}

class _EtudiantProfilState extends State<EtudiantProfil> {
  List<NotificationModel> _notifications = [];
  bool _loading = true;
  String _userName = '';
  String _userIdentifiant = '';
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      final userId = await Services.auth.getUserId();
      final userName = await Services.auth.getUserType();
      if (userId != null) {
        _userId = userId;
        final notifs = await Services.notifications.mesNotifications(userId);
        setState(() {
          _notifications = notifs;
          _userName = userName ?? 'Étudiant';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() { _loading = false; });
    }
  }

  Future<void> _marquerToutLu() async {
    for (final notif in _notifications.where((n) => !n.lue)) {
      await Services.notifications.marquerLue(notif.notificationId!);
    }
    _chargerDonnees();
  }

  Future<void> _deconnexion() async {
    await Services.auth.deconnexion();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final nonLues = _notifications.where((n) => !n.lue).length;

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
            children: [
              // Avatar et infos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      child: Text(
                        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'E',
                        style: GoogleFonts.poppins(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(_userName, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Étudiant', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Notifications
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A5F))),
                  if (nonLues > 0)
                    TextButton(
                      onPressed: _marquerToutLu,
                      child: Text('Tout lire ($nonLues)', style: const TextStyle(color: Color(0xFF2563EB))),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _notifications.isEmpty
                  ? Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('Aucune notification')),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notif = _notifications[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: notif.lue ? Colors.white : const Color(0xFFEFF6FF),
                    child: ListTile(
                      leading: Icon(
                        notif.lue ? Icons.notifications_none : Icons.notifications,
                        color: notif.lue ? Colors.grey : const Color(0xFF2563EB),
                      ),
                      title: Text(notif.titre, style: GoogleFonts.poppins(fontWeight: notif.lue ? FontWeight.normal : FontWeight.bold, fontSize: 13)),
                      subtitle: Text(notif.message, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                      onTap: () async {
                        if (!notif.lue) {
                          await Services.notifications.marquerLue(notif.notificationId!);
                          _chargerDonnees();
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Bouton déconnexion
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _deconnexion,
                  icon: const Icon(Icons.logout),
                  label: Text('Se déconnecter', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}