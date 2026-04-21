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
      await prefs.setString('userType', data['utilisateur']['type_utilisateur'] ?? '');
      return data;
    }
    final err = jsonDecode(r.body);
    throw Exception(err['erreur'] ?? err['message'] ?? 'Erreur de connexion');
  }

  Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString('token');

  Future<String?> getUserType() async =>
      (await SharedPreferences.getInstance()).getString('userType');

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
