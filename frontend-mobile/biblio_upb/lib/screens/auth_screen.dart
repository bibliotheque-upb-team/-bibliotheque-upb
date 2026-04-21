import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblio_upb/services/service_locator.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isConnexion = true;
  bool _loading = false;
  String? _erreur;

  // Connexion
  final _identifiantCtrl = TextEditingController();

  // Inscription
  final _emailCtrl = TextEditingController();
  final _mdpCtrl = TextEditingController();
  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _filiereCtrl = TextEditingController();
  final _anneeCtrl = TextEditingController();

  Future<void> _connexion() async {
    setState(() { _loading = true; _erreur = null; });
    try {
      await Services.auth.connexion(_identifiantCtrl.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, '/etudiant');
    } catch (e) {
      setState(() { _erreur = e.toString().replaceAll('Exception: ', ''); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _inscription() async {
    setState(() { _loading = true; _erreur = null; });
    try {
      await Services.auth.inscription(
          email: _emailCtrl.text.trim(), motDePasse: _mdpCtrl.text.trim(),
          nom: _nomCtrl.text.trim(), prenom: _prenomCtrl.text.trim(),
          filiere: _filiereCtrl.text.trim(), anneeEtude: _anneeCtrl.text.trim());
      if (mounted) Navigator.pushReplacementNamed(context, '/etudiant');
    } catch (e) {
      setState(() { _erreur = e.toString().replaceAll('Exception: ', ''); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('📚 Bibliothèque UPB',
                      style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB))),
                  const SizedBox(height: 8),
                  Text(_isConnexion ? 'Connexion' : 'Inscription',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  if (_erreur != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text(_erreur!, style: const TextStyle(color: Colors.red)),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_isConnexion) ...[
                    TextField(
                        controller: _identifiantCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Identifiant',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person))),
                  ] else ...[
                    TextField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: 'Prénom', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _nomCtrl, decoration: const InputDecoration(labelText: 'Nom', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _mdpCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _filiereCtrl, decoration: const InputDecoration(labelText: 'Filière', border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    TextField(controller: _anneeCtrl, decoration: const InputDecoration(labelText: 'Année d\'étude', border: OutlineInputBorder())),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : (_isConnexion ? _connexion : _inscription),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(_isConnexion ? 'Se connecter' : 'S\'inscrire',
                          style: GoogleFonts.poppins(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() { _isConnexion = !_isConnexion; _erreur = null; }),
                    child: Text(
                        _isConnexion ? 'Pas de compte ? S\'inscrire' : 'Déjà un compte ? Se connecter',
                        style: const TextStyle(color: Color(0xFF2563EB))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}