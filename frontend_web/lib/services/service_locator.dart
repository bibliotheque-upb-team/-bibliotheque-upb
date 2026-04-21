import '../config/api_config.dart';
import 'auth_service.dart';
import 'biblio_service.dart';
import 'admin_service.dart';

class Services {
  static final auth = AuthService(ApiConfig.baseUrl);
  static final biblio = BiblioService(ApiConfig.baseUrl, auth);
  static final admin = AdminService(ApiConfig.baseUrl, auth);
}
