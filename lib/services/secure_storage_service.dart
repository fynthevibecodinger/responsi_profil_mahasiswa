import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service untuk menyimpan isi catatan secara terenkripsi.
class SecureStorageService {
  static const String _contentPrefix = 'note_content_';

  final FlutterSecureStorage _storage;

  /// Membuat service secure storage.
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  String _key(String noteId) => '$_contentPrefix$noteId';

  /// Menyimpan isi catatan terenkripsi untuk [noteId].
  Future<void> saveContent(String noteId, String content) {
    return _storage.write(key: _key(noteId), value: content);
  }

  /// Membaca isi catatan terenkripsi untuk [noteId].
  Future<String?> getContent(String noteId) {
    return _storage.read(key: _key(noteId));
  }

  /// Menghapus isi catatan untuk [noteId].
  Future<void> deleteContent(String noteId) {
    return _storage.delete(key: _key(noteId));
  }
}
