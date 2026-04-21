import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class BiblioService {
  final String baseUrl;
  final AuthService auth;
  BiblioService(this.baseUrl, this.auth);

  // --- DASHBOARD ---
  Future<Map<String, dynamic>> dashboard() async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/biblio/dashboard'), headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur dashboard');
  }

  // --- LIVRES ---
  Future<List<dynamic>> listerLivres() async {
    final r = await http.get(Uri.parse('$baseUrl/livres'));
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur livres');
  }

  Future<void> ajouterLivre(Map<String, dynamic> data) async {
    final h = await auth.authHeaders();
    await http.post(Uri.parse('$baseUrl/livres'),
        headers: h, body: jsonEncode(data));
  }

  Future<void> modifierLivre(int id, Map<String, dynamic> data) async {
    final h = await auth.authHeaders();
    await http.put(Uri.parse('$baseUrl/livres/$id'),
        headers: h, body: jsonEncode(data));
  }

  Future<void> supprimerLivre(int id) async {
    final h = await auth.authHeaders();
    await http.delete(Uri.parse('$baseUrl/livres/$id'), headers: h);
  }

  // --- RESERVATIONS ---
  Future<List<dynamic>> reservationsEnAttente() async {
    final h = await auth.authHeaders();
    final r = await http.get(
        Uri.parse('$baseUrl/reservations/en-attente'), headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur réservations');
  }

  Future<void> confirmerReservation(int id) async {
    final h = await auth.authHeaders();
    await http.put(Uri.parse('$baseUrl/reservations/$id/confirmer'), headers: h);
  }

  Future<void> refuserReservation(int id) async {
    final h = await auth.authHeaders();
    await http.put(Uri.parse('$baseUrl/reservations/$id/refuser'), headers: h);
  }

  // --- ANNOTATIONS ---
  Future<List<dynamic>> toutesAnnotations() async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/annotations'), headers: h);
    if (r.statusCode == 200) return jsonDecode(r.body);
    throw Exception('Erreur annotations');
  }

  Future<void> supprimerAnnotation(int id) async {
    final h = await auth.authHeaders();
    await http.delete(Uri.parse('$baseUrl/annotations/$id'), headers: h);
  }

  // --- NOTIFICATIONS ---
  Future<void> broadcast(String titre, String message) async {
    final h = await auth.authHeaders();
    await http.post(Uri.parse('$baseUrl/notifications/broadcast'),
        headers: h,
        body: jsonEncode({'titre': titre, 'message': message}));
  }
}
