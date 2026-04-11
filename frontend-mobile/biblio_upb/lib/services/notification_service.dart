import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import 'auth_service.dart';

class NotificationFlutterService {
  final String baseUrl;
  final AuthService auth;
  NotificationFlutterService(this.baseUrl, this.auth);

  Future<List<NotificationModel>> mesNotifications(int id) async {
    final h = await auth.authHeaders();
    final r = await http.get(
        Uri.parse('$baseUrl/notifications/utilisateur/$id'),
        headers: h);
    if (r.statusCode == 200)
      return (jsonDecode(r.body) as List)
          .map((j) => NotificationModel.fromJson(j))
          .toList();
    return [];
  }

  Future<void> marquerLue(int id) async {
    final h = await auth.authHeaders();
    await http.put(
        Uri.parse('$baseUrl/notifications/$id/lire'),
        headers: h);
  }
}