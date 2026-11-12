/// Kumpulan fungsi validasi dan sanitasi input pengguna.
class Validators {
  /// Memvalidasi format email.
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email.trim());
  }

  /// Memvalidasi input yang wajib diisi.
  static String? validateRequired(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Memvalidasi judul catatan (3-50 karakter).
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    final length = value.trim().length;
    if (length < 3) {
      return 'Judul minimal 3 karakter';
    }
    if (length > 50) {
      return 'Judul maksimal 50 karakter';
    }
    return null;
  }

  /// Memvalidasi isi catatan (10-1000 karakter).
  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Isi catatan tidak boleh kosong';
    }
    final length = value.trim().length;
    if (length < 10) {
      return 'Isi catatan minimal 10 karakter';
    }
    if (length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }
    return null;
  }

  /// Memvalidasi format email untuk form profil.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Membersihkan karakter berbahaya menjadi HTML entities.
  static String sanitize(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .trim();
  }
}
