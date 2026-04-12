import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblio_upb/services/service_locator.dart';

class EtudiantJeux extends StatefulWidget {
  const EtudiantJeux({super.key});
  @override
  State<EtudiantJeux> createState() => _EtudiantJeuxState();
}

class _EtudiantJeuxState extends State<EtudiantJeux> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _quiz = [];
  List<dynamic> _classement = [];
  List<dynamic> _badges = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    try {
      final quiz = await Services.gamification.listerQuiz();
      final classement = await Services.gamification.classement();
      final userId = await Services.auth.getUserId();
      List badges = [];
      if (userId != null) {
        badges = await Services.gamification.mesBadges(userId);
      }
      setState(() {
        _quiz = quiz;
        _classement = classement;
        _badges = badges;
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; });
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
            Tab(text: 'Défis'),
            Tab(text: 'Classement'),
            Tab(text: 'Badges'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          // Onglet Défis
          _quiz.isEmpty
              ? const Center(child: Text('Aucun quiz disponible'))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _quiz.length,
            itemBuilder: (context, index) {
              final q = _quiz[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q['titre'] ?? 'Quiz', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('${q['pointsRecompense'] ?? 0} points', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF2563EB)),
                        child: const Text('Jouer'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Onglet Classement
          _classement.isEmpty
              ? const Center(child: Text('Classement vide'))
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _classement.length,
            itemBuilder: (context, index) {
              final item = _classement[index];
              final medals = ['🥇', '🥈', '🥉'];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Text(index < 3 ? medals[index] : '${index + 1}', style: const TextStyle(fontSize: 24)),
                  title: Text(item['nom'] ?? 'Étudiant', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  trailing: Text('${item['scoreReputation'] ?? 0} pts', style: GoogleFonts.poppins(color: const Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),

          // Onglet Badges
          _badges.isEmpty
              ? const Center(child: Text('Aucun badge obtenu'))
              : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: _badges.length,
            itemBuilder: (context, index) {
              final badge = _badges[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(badge['nom'] ?? 'Badge', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
                      Text('${badge['pointsRequis'] ?? 0} pts', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}