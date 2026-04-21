import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl;
  AuthService(this.baseUrl);

  Future<Map<String, dynamic>> connexion(String identifiant, String motDePasse) async {
    final r = await http.post(
      Uri.parse('$baseUrl/auth/connexion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifiant': identifiant, 'motDePasse': motDePasse}),
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('userId', data['utilisateur']['utilisateurId'] ?? 0);
      await prefs.setString('userIdentifiant', data['utilisateur']['identifiant'] ?? '');
      await prefs.setString('userName', '${data['utilisateur']['prenom']} ${data['utilisateur']['nom']}');
      await prefs.setString('userType', data['utilisateur']['type_utilisateur'] ?? 'ETUDIANT');
      return data;
    }
    final err = jsonDecode(r.body);
    throw Exception(err['erreur'] ?? err['message'] ?? 'Erreur de connexion');
  }

  Future<Map<String, dynamic>> inscription({
    required String email,
    required String motDePasse,
    required String nom,
    required String prenom,
    required String filiere,
    required String anneeEtude,
  }) async {
    final r = await http.post(
      Uri.parse('$baseUrl/auth/inscription'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'motDePasse': motDePasse,
        'nom': nom,
        'prenom': prenom,
        'filiere': filiere,
        'anneeEtude': anneeEtude,
        'role': 'ETUDIANT',
      }),
    );
    if (r.statusCode == 200) {
      final data = jsonDecode(r.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('userName', '${data['utilisateur']['prenom']} ${data['utilisateur']['nom']}');
      await prefs.setInt('userId', data['utilisateur']['utilisateurId'] ?? 0);
      await prefs.setString('userType', data['utilisateur']['type_utilisateur'] ?? 'ETUDIANT');
      return data;
    }
    final err = jsonDecode(r.body);
    throw Exception(err['erreur'] ?? err['message'] ?? 'Erreur inscription');
  }

  Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<int?> getUserId() async =>
      (await SharedPreferences.getInstance()).getInt('userId');

  Future<String?> getUserType() async =>
      (await SharedPreferences.getInstance()).getString('userType');

  Future<String?> getUserName() async =>
      (await SharedPreferences.getInstance()).getString('userName');

  Future<void> deconnexion() async =>
      (await SharedPreferences.getInstance()).clear();

  Future<Map<String, String>> authHeaders() async {
    final t = await getToken();
    return {
      'Content-Type': 'application/json',
      if (t != null) 'Authorization': 'Bearer $t',
    };
  }
}