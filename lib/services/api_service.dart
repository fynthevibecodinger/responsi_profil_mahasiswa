import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../utils/logger.dart';

/// Service komunikasi HTTP ke API publik.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  /// Membuat service API.
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari endpoint `/users`.
  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      Logger.debug('[GET] /users');

      final response = await _client
          .get(Uri.parse('$_baseUrl/users'), headers: _buildHeaders())
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));

      Logger.info('Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Data bukan list');
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } catch (_) {
      throw Exception('Terjadi kesalahan saat memuat data.');
    }
  }

  Map<String, String> _buildHeaders() {
    return {'Content-Type': 'application/json', 'X-API-Key': AppConfig.apiKey};
  }

  /// Menutup koneksi HTTP.
  void dispose() {
    _client.close();
  }
}
