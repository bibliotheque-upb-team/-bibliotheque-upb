import 'package:flutter/material.dart';

class AuthScreenWeb extends StatefulWidget {
  const AuthScreenWeb({super.key});

  @override
  State<AuthScreenWeb> createState() => _AuthScreenWebState();
}

class _AuthScreenWebState extends State<AuthScreenWeb> {
  final TextEditingController _idController = TextEditingController();
  bool _isLoading = false;
  String? _erreur;

  Future<void> _connexion() async {
    setState(() {
      _isLoading = true;
      _erreur = null;
    });

    final identifiant = _idController.text.trim();

    if (identifiant.isEmpty) {
      setState(() {
        _erreur = 'Veuillez entrer votre identifiant';
        _isLoading = false;
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    if (identifiant.startsWith('LIB')) {
      Navigator.pushReplacementNamed(context, '/biblio');
    } else if (identifiant.startsWith('ADM')) {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      setState(() {
        _erreur = 'Accès non autorisé. Utilisez un compte bibliothécaire ou administrateur.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.local_library, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'UPB BIBLIO',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Color(0xFF1a1a2e),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'ESPACE ADMINISTRATION',
                style: TextStyle(fontSize: 12, letterSpacing: 2, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'IDENTIFIANT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: 'Ex: LIB001, ADM001...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF0F2F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              if (_erreur != null) ...[
                const SizedBox(height: 8),
                Text(_erreur!, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _connexion,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Connexion...' : 'ACCÉDER',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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