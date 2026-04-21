import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class GamificationService {
  final String baseUrl;
  final AuthService auth;
  GamificationService(this.baseUrl, this.auth);

  Future<List<dynamic>> listerQuiz() async {
    final r = await http.get(Uri.parse('$baseUrl/gamification/quiz'));
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur');
  }

  Future<List<dynamic>> getQuestions(int id) async {
    final h = await auth.authHeaders();
    final r = await http.get(
        Uri.parse('$baseUrl/gamification/quiz/$id/questions'),
        headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur');
  }

  Future<Map<String, dynamic>> soumettre(
      int qId, int eId, List<int> rep) async {
    final h = await auth.authHeaders();
    final r = await http.post(
        Uri.parse('$baseUrl/gamification/quiz/$qId/soumettre'),
        headers: h,
        body: jsonEncode({'etudiantId': eId, 'reponses': rep}));
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur soumission quiz');
  }

  Future<List<dynamic>> classement() async {
    final r = await http.get(Uri.parse('$baseUrl/gamification/classement'));
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur');
  }

  Future<List<dynamic>> mesBadges(int id) async {
    final h = await auth.authHeaders();
    final r = await http.get(
        Uri.parse('$baseUrl/gamification/badges/$id'),
        headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur');
  }
}