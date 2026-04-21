import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/livre.dart';
import '../models/catalogue.dart';
import 'auth_service.dart';

class LivreService {
  final String baseUrl;
  final AuthService auth;
  LivreService(this.baseUrl, this.auth);

  Future<List<Catalogue>> listerCatalogues() async {
    final r = await http.get(Uri.parse('$baseUrl/catalogues'));
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List)
          .map((j) => Catalogue.fromJson(j))
          .toList();
    throw Exception('Erreur');
  }

  Future<List<Livre>> livresParCatalogue(int id) async {
    final r = await http.get(Uri.parse('$baseUrl/catalogues/$id/livres'));
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List)
          .map((j) => Livre.fromJson(j))
          .toList();
    throw Exception('Erreur');
  }

  Future<List<Livre>> listerTous() async {
    final r = await http.get(Uri.parse('$baseUrl/livres'));
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List)
          .map((j) => Livre.fromJson(j))
          .toList();
    throw Exception('Erreur');
  }

  Future<List<Livre>> rechercher(String q) async {
    final r = await http.get(Uri.parse('$baseUrl/livres/recherche?titre=$q'));
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List)
          .map((j) => Livre.fromJson(j))
          .toList();
    throw Exception('Erreur');
  }

  Future<void> emprunter(int eId, int lId) async {
    final h = await auth.authHeaders();
    final r = await http.post(
        Uri.parse('$baseUrl/emprunts'),
        headers: h,
        body: jsonEncode({'etudiantId': eId, 'livreId': lId}));
    if (r.statusCode != 200) {
      final err = jsonDecode(r.body);
      throw Exception(err['erreur'] ?? err['message'] ?? 'Erreur emprunt');
    }
  }

  Future<void> reserver(int eId, int lId) async {
    final h = await auth.authHeaders();
    final r = await http.post(
        Uri.parse('$baseUrl/reservations'),
        headers: h,
        body: jsonEncode({'etudiantId': eId, 'livreId': lId}));
    if (r.statusCode != 200) {
      final err = jsonDecode(r.body);
      throw Exception(err['erreur'] ?? err['message'] ?? 'Erreur réservation');
    }
  }
}