import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/emprunt.dart';
import '../models/reservation.dart';
import 'auth_service.dart';

class EmpruntService {
  final String baseUrl;
  final AuthService auth;
  EmpruntService(this.baseUrl, this.auth);

  Future<List<Emprunt>> mesEmprunts(int id) async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/emprunts/etudiant/$id'), headers: h);
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List).map((j) => Emprunt.fromJson(j)).toList();
    throw Exception('Erreur emprunts');
  }

  Future<void> retourner(int id) async {
    final h = await auth.authHeaders();
    await http.put(Uri.parse('$baseUrl/emprunts/$id/retour'), headers: h);
  }

  Future<void> prolonger(int empruntId, int etudiantId) async {
    final h = await auth.authHeaders();
    final r = await http.put(
      Uri.parse('$baseUrl/emprunts/$empruntId/prolonger'),
      headers: h,
      body: jsonEncode({'etudiantId': etudiantId}),
    );
    if (r.statusCode != 200)
      throw Exception(jsonDecode(r.body)['erreur'] ?? 'Erreur prolongation');
  }

  Future<List<Reservation>> mesReservations(int id) async {
    final h = await auth.authHeaders();
    final r = await http.get(Uri.parse('$baseUrl/reservations/etudiant/$id'), headers: h);
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List).map((j) => Reservation.fromJson(j)).toList();
    throw Exception('Erreur réservations');
  }

  Future<void> annulerReservation(int id) async {
    final h = await auth.authHeaders();
    await http.put(Uri.parse('$baseUrl/reservations/$id/annuler'), headers: h);
  }
}
