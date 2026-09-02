import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get backendUrl {
    const buildUrl = String.fromEnvironment('BACKEND_URL');
    return buildUrl.isNotEmpty
        ? buildUrl
        : dotenv.env['BACKEND_URL'] ?? 'http://localhost:3000';
  }
}
