import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dimuat dari file `.env`.
///
/// Tidak ada credential yang di-hardcode di dalam kode sumber.
class AppConfig {
  /// Base URL API dari environment variable `BASE_URL`.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// API key dari environment variable `API_KEY`.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Timeout request HTTP dalam detik.
  static const int timeoutSeconds = 10;

  /// Memeriksa apakah konfigurasi utama sudah terisi.
  static bool isConfigured() {
    return baseUrl.isNotEmpty && apiKey.isNotEmpty;
  }
}
