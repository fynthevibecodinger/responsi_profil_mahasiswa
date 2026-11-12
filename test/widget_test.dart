import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/models/note.dart';
import 'package:responsi_profil_mahasiswa/models/student.dart';
import 'package:responsi_profil_mahasiswa/utils/validators.dart';

void main() {
  group('Validators', () {
    test('judul valid dan tidak valid', () {
      expect(Validators.validateTitle('Catatan'), isNull);
      expect(Validators.validateTitle('ab'), isNotNull);
      expect(Validators.validateTitle('a' * 51), isNotNull);
    });

    test('isi catatan minimal 10 karakter', () {
      expect(Validators.validateContent('materi kuliah hari ini'), isNull);
      expect(Validators.validateContent('pendek'), isNotNull);
    });

    test('sanitize membersihkan karakter berbahaya', () {
      expect(
        Validators.sanitize('<script>"x"</script>'),
        '&lt;script&gt;&quot;x&quot;&lt;/script&gt;',
      );
    });
  });

  group('Model', () {
    test('metadata Note tidak menyimpan content', () {
      final note = Note(
        id: '1',
        title: 'Judul',
        date: DateTime(2026, 1, 1),
        content: 'rahasia',
      );

      expect(note.toMetadataJson().containsKey('content'), isFalse);
    });

    test('Student dapat dikonversi bolak-balik', () {
      const student = Student(
        name: 'A',
        nim: '1',
        programStudi: 'Informatika',
        email: 'a@example.com',
      );

      final result = Student.fromMap(student.toMap());
      expect(result.name, student.name);
      expect(result.email, student.email);
    });
  });
}
