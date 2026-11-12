import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';
import '../utils/logger.dart';

/// Repository catatan kuliah.
///
/// Metadata disimpan sebagai JSON list di SharedPreferences, sedangkan
/// isi catatan disimpan terenkripsi di secure storage.
class NoteRepository {
  static const String _metadataKey = 'notes_metadata';

  final SecureStorageService _secureStorage;

  NoteRepository({SecureStorageService? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageService();

  List<Map<String, dynamic>> _decodeMetadata(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<void> _writeMetadata(
    SharedPreferences prefs,
    List<Map<String, dynamic>> metadata,
  ) async {
    final success = await prefs.setString(_metadataKey, jsonEncode(metadata));
    if (!success) {
      throw Exception('Gagal menyimpan metadata catatan.');
    }
  }

  /// Memuat seluruh catatan beserta isinya.
  Future<List<Note>> loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadata = _decodeMetadata(prefs.getString(_metadataKey));
      final notes = <Note>[];

      for (final item in metadata) {
        final note = Note.fromMetadataJson(item);
        final content = await _secureStorage.getContent(note.id);
        notes.add(note.copyWith(content: content));
      }

      notes.sort((a, b) => b.date.compareTo(a.date));
      return notes;
    } catch (error) {
      Logger.error('Gagal memuat catatan', error: error);
      throw Exception('Gagal memuat catatan.');
    }
  }

  /// Menambahkan atau memperbarui catatan.
  Future<void> addNote(Note note) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadata = _decodeMetadata(prefs.getString(_metadataKey));

      await _secureStorage.saveContent(note.id, note.content ?? '');

      metadata.removeWhere((item) => item['id'] == note.id);
      metadata.add(note.toMetadataJson());

      try {
        await _writeMetadata(prefs, metadata);
      } catch (_) {
        await _secureStorage.deleteContent(note.id);
        rethrow;
      }
    } catch (error) {
      Logger.error('Gagal menyimpan catatan', error: error);
      throw Exception('Gagal menyimpan catatan.');
    }
  }

  /// Menghapus catatan dan isinya.
  Future<void> deleteNote(String noteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final metadata = _decodeMetadata(prefs.getString(_metadataKey))
        ..removeWhere((item) => item['id'] == noteId);

      await _writeMetadata(prefs, metadata);
      await _secureStorage.deleteContent(noteId);
    } catch (error) {
      Logger.error('Gagal menghapus catatan', error: error);
      throw Exception('Gagal menghapus catatan.');
    }
  }
}
