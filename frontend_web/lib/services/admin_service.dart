import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AdminService {
  final String baseUrl;
  final AuthService auth;
  AdminService(this.baseUrl, this.auth);

  Future<Map<String, dynamic>> dashboard() async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/admin/dashboard'), headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur dashboard admin');
  }

  Future<List<dynamic>> listerUtilisateurs() async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/admin/utilisateurs'), headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur utilisateurs');
  }

  Future<void> changerStatut(int id, bool actif) async {
    final h = await auth.authHeaders();
    await http.put(Uri.parse('$baseUrl/admin/utilisateurs/$id/statut'),
        headers: h, body: jsonEncode({'actif': actif}));
  }

  Future<List<dynamic>> listerAudits() async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/admin/audits'), headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur audits');
  }
}
