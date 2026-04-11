import '../config/api_config.dart';
import 'auth_service.dart';
import 'livre_service.dart';
import 'emprunt_service.dart';
import 'gamification_service.dart';
import 'notification_service.dart';

class Services {
  static final auth = AuthService(ApiConfig.baseUrl);
  static final livres = LivreService(ApiConfig.baseUrl, auth);
  static final emprunts = EmpruntService(ApiConfig.baseUrl, auth);
  static final gamification = GamificationService(ApiConfig.baseUrl, auth);
  static final notifications = NotificationFlutterService(ApiConfig.baseUrl, auth);
}